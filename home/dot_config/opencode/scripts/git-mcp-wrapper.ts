#!/usr/bin/env bun

type JsonRpcId = string | number | null

type ParsedMessages = {
  messages: unknown[]
  remaining: string
}

type HeaderBoundary = {
  index: number
  separatorLength: 2 | 4
}

type ParsedRequest = {
  id: JsonRpcId | undefined
  method: string | undefined
}

const textDecoder = new TextDecoder()

const writeMessage = (message: unknown) => {
  process.stdout.write(`${JSON.stringify(message)}\n`)
}

const writeResult = (id: JsonRpcId | undefined, result: unknown) => {
  writeMessage({ jsonrpc: "2.0", id, result })
}

const writeError = (id: JsonRpcId | undefined, code: number, message: string) => {
  writeMessage({
    jsonrpc: "2.0",
    id,
    error: {
      code,
      message,
    },
  })
}

const findHeaderBoundary = (buffer: string): HeaderBoundary | null => {
  const crlf = buffer.indexOf("\r\n\r\n")
  if (crlf !== -1) {
    return { index: crlf, separatorLength: 4 }
  }

  const lf = buffer.indexOf("\n\n")
  if (lf !== -1) {
    return { index: lf, separatorLength: 2 }
  }

  return null
}

const parseMessages = (buffer: string): ParsedMessages => {
  const messages: unknown[] = []
  let working = buffer

  while (true) {
    const boundary = findHeaderBoundary(working)
    if (!boundary) break

    const headerBlock = working.slice(0, boundary.index)
    const lines = headerBlock.split(/\r?\n/)
    const contentLengthHeader = lines.find((line) =>
      line.toLowerCase().startsWith("content-length:"),
    )

    if (!contentLengthHeader) {
      throw new Error("Missing Content-Length header")
    }

    const contentLength = Number(contentLengthHeader.split(":")[1]?.trim() ?? "")
    if (!Number.isFinite(contentLength)) {
      throw new Error("Invalid Content-Length header")
    }

    const bodyStart = boundary.index + boundary.separatorLength
    const bodyEnd = bodyStart + contentLength
    if (working.length < bodyEnd) break

    const body = working.slice(bodyStart, bodyEnd)
    messages.push(JSON.parse(body))
    working = working.slice(bodyEnd)
  }

  return { messages, remaining: working }
}

const parseLineDelimitedMessages = (buffer: string): ParsedMessages => {
  const lines = buffer.split(/\r?\n/)
  const lastLine = lines.pop() ?? ""
  const messages: unknown[] = []

  for (const line of lines) {
    const trimmed = line.trim()
    if (!trimmed) continue
    messages.push(JSON.parse(trimmed))
  }

  return { messages, remaining: lastLine }
}

const parseRequest = (value: unknown): ParsedRequest | null => {
  if (typeof value !== "object" || value === null) return null

  const record = value as Record<string, unknown>
  const rawId = record.id
  const id =
    typeof rawId === "string" || typeof rawId === "number" || rawId === null
      ? rawId
      : undefined

  const rawMethod = record.method
  const method = typeof rawMethod === "string" ? rawMethod : undefined

  return { id, method }
}

const showTopLevel = Bun.spawnSync(["git", "rev-parse", "--show-toplevel"], {
  cwd: process.cwd(),
  stderr: "ignore",
  stdout: "pipe",
})

if (showTopLevel.exitCode === 0) {
  const repoRoot = textDecoder.decode(showTopLevel.stdout).trim()
  const child = Bun.spawn(["uvx", "mcp-server-git", "--repository", repoRoot], {
    cwd: process.cwd(),
    stdin: "inherit",
    stdout: "inherit",
    stderr: "inherit",
  })

  const code = await child.exited
  process.exit(code)
}

let stdinBuffer = ""

process.stdin.setEncoding("utf8")
process.stdin.resume()
process.stdin.on("data", (chunk: string) => {
  stdinBuffer += chunk

  try {
    let parsed = parseMessages(stdinBuffer)
    if (parsed.messages.length === 0 && !stdinBuffer.includes("Content-Length:")) {
      parsed = parseLineDelimitedMessages(stdinBuffer)
    }

    const { messages, remaining } = parsed
    stdinBuffer = remaining

    for (const rawMessage of messages) {
      const message = parseRequest(rawMessage)
      if (!message) continue

      if (message.method === "initialize") {
        writeResult(message.id, {
          protocolVersion: "2024-11-05",
          capabilities: {
            tools: {},
          },
          serverInfo: {
            name: "git-mcp-wrapper",
            version: "1.0.0",
          },
        })
        continue
      }

      if (message.method === "initialized") {
        continue
      }

      if (message.method === "tools/list") {
        writeResult(message.id, { tools: [] })
        continue
      }

      if (message.method === "tools/call") {
        writeError(
          message.id,
          -32000,
          "Git MCP unavailable: current directory is not inside a Git repository.",
        )
        continue
      }

      if (message.id !== undefined) {
        writeError(message.id, -32601, `Method not found: ${message.method ?? "unknown"}`)
      }
    }
  } catch {
    // If malformed data arrives, keep the process alive.
    // OpenCode will retry MCP handshake if needed.
  }
})
