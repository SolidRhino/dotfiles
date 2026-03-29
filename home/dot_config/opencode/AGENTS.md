# AGENTS.md — OpenCode Global Config

This file is loaded by every agent in every session. Follow these conventions
when reading, editing, or extending this config repository.

---

## What this repo is

Personal global OpenCode config loaded from `~/.config/opencode/` on every
session. It contains JSONC config files, Bun scripts, Markdown agent/command
prompts, and local plugin clones.

---

## Build / run commands

This repo has no build step. The config is loaded directly by OpenCode at startup.

```sh
# Verify all MCP servers are healthy after any change to opencode.jsonc
opencode mcp list

# Validate git-mcp-wrapper runs without errors (should block on stdin)
bun scripts/git-mcp-wrapper.ts

# Force-refresh shell-strategy file via startup wrapper
rm -f ~/.cache/opencode-shell-strategy.last-check && scripts/opencode-start.sh --help >/dev/null

# Check if a plugin package has a newer version
npm info <plugin-name> version

# Verify LSP tools are installed
fish-lsp --version && taplo --version && marksman --version
```

There are no test files. Verification is done manually by running
`opencode mcp list` from both a git repo directory and a non-git directory.

---

## File format conventions

### JSONC files (`opencode.jsonc`, `dcp.jsonc`)

- Use `//` comments to group and explain sections.
- Section comments use the pattern: `// === Section Name ===`
- String values use double quotes; no trailing commas on last items.
- All config is written for human readability first.

### TypeScript (`scripts/*.ts`)

- Written for **Bun** — use `Bun.*` APIs where available.
- Prefer TypeScript for all new scripts — `bun run file.ts` works with no compile step.
- ES module style: use `const`, arrow functions, `await` at top level.
- Prefer `const` over `let`; never use `var`.
- Function naming: `camelCase`, descriptive verbs (`writeMessage`, `parseMessages`).
- Error handling: catch silently only when failure is expected and recoverable
  (e.g. MCP malformed input); always let unexpected errors surface.
- No external dependencies in scripts — use Bun built-ins only.
- TypeScript config is in `tsconfig.json` — strict mode, no emit, `bun-types`, bundler resolution.

### Shell scripts (`scripts/*.sh`)

- Written in POSIX `sh` (`#!/usr/bin/env sh`) — not bash, not fish.
- Use `set -eu` at the top for strict error handling.
- Always end launcher scripts with `exec <command> "$@"` for clean arg passthrough.
- Keep logic minimal and portable — avoid bashisms.
- Test with `sh -n scripts/<file>.sh` to check syntax.

### Markdown files (`agents/*.md`, `command/*.md`)

- Agent files start with a YAML frontmatter block specifying `model:`.
- Write agent prompts in second person ("You are the …").
- Use `##` for major sections within agent prompts.
- Keep agent files focused: one agent = one clear responsibility.
- Command files start with YAML frontmatter specifying `description:`.

---

## Code style — JavaScript (scripts/)

```js
// Good: concise, named arrow functions
const writeMessage = (message) => {
  process.stdout.write(`${JSON.stringify(message)}\n`)
}

// Good: early return / guard pattern
if (showTopLevel.exitCode !== 0) {
  // handle no-repo case
}

// Bad: var, implicit globals, mutable state where avoidable
```

- No semicolons — existing scripts use none, match that style.
- 2-space indentation.
- Opening braces on same line as function/if/for.
- Trailing comma on last items in multi-line objects/arrays.
- `??` over `||` for nullish checks; `?.` for optional chaining.

---

## Naming conventions

| Thing | Convention | Example |
|---|---|---|
| JSONC config keys | `camelCase` | `"defaultAgent"`, `"protectedTools"` |
| Script functions | `camelCase` verbs | `writeError`, `findHeaderBoundary` |
| Agent/command filenames | `kebab-case` | `debug.md`, `plannotator-last.md` |
| Script filenames | `kebab-case` | `git-mcp-wrapper.ts` |
| Plugin folder names | `kebab-case` | `shell-strategy/` |

---

## Config editing rules

1. **Always verify after changes.** Run `opencode mcp list` after editing
   `opencode.jsonc`.
2. **Minimal changes only.** Don't rewrite working config sections unless
   there's a clear reason. Prefer targeted edits.
3. **Keep permissions conservative.** Bash defaults to `ask`. Only add explicit
   `allow` entries for commands you regularly run and trust.
4. **Never allow edit of `.env*` files.** The `"**/.env*": "deny"` rule in the
   `edit` permission block must stay in place.
5. **Do not add npm plugins without verifying they exist.** Run
   `npm info <plugin> version` before adding any new plugin entry.
6. **Do not install plugins as global npm packages.** OpenCode loads plugins
   from the `"plugin"` array in `opencode.jsonc` — that's the only source.
7. **Do not edit `opencode-notifier-state.json`.** It is auto-managed by the
   `@mohak34/opencode-notifier` plugin. Edit `opencode-notifier.json` for
   notification preferences (sound, system, suppress-when-focused, etc.).

---

## DCP context pruning

`dcp.jsonc` controls automatic context compression. When editing:

- `maxContextLimit` and `minContextLimit` must stay as percentage strings
  (`"75%"`, `"40%"`) — not absolute token counts.
- `protectedFilePatterns` uses glob patterns relative to repo root, not
  absolute paths.
- `experimental.allowSubAgents` should remain `false` unless specifically
  testing sub-agent compression.

---

## MCP server changes

Currently configured MCP servers in `opencode.jsonc`:

| Server | Type | Purpose |
|---|---|---|
| `serena` | local (uvx) | Symbol-level code navigation — prefer over raw grep in large codebases |
| `nixos` | local (uvx) | NixOS package and option search |
| `context7` | local (npx) | Up-to-date library and framework documentation |
| `sequential-thinking` | local (npx) | Multi-step structured reasoning chains |
| `git` | local (bun) | Git operations via `scripts/git-mcp-wrapper.ts` |
| `grep-app` | remote | Search public GitHub repos for real-world code patterns |

Rules when editing MCP config:
- The `git` MCP entry points to `scripts/git-mcp-wrapper.ts` via Bun.
  Do not revert it to `uvx mcp-server-git --repository .` — that crashes
  outside git repos.
- When adding a new MCP server, verify connectivity with `opencode mcp list`
  before committing.
- Remote MCP servers (like `grep-app`) may show disconnected offline — this
  is expected and not a config error.

---

## Agent prompt style

- State the agent's role in sentence 1.
- List tools available and when to use each (under "Tools at your disposal").
- Provide a numbered workflow that matches how the agent should reason.
- End with a one-sentence behavioral constraint or guiding principle.
- Do not duplicate system-level constraints (permissions, formatters) — those
  are handled by `opencode.jsonc`.

---

## Memory strategy

Two complementary memory systems are active in every session. Use them for different purposes:

| Layer | Tool | What belongs here |
|---|---|---|
| **Active blocks** | `memory_list`, `memory_set`, `memory_replace` | Short, durable rules injected into every context window — behavior guidelines, collaboration preferences, active project context |
| **Journal** | `memory_set` with `#tag` | One-off findings, investigation notes, historical decisions — searchable but not always-injected |
| **Serena** | `serena_write_memory` | Deeper per-project context — architecture notes, conventions, past decisions — loaded on demand, not injected |

### Active block scopes

| Block | Scope | Purpose |
|---|---|---|
| `persona` | global | Stable agent behavior rules — concise and `read_only` |
| `human` | global | Stable user collaboration preferences — concise and `read_only` |
| `current` | project | Short-lived task context (e.g. active PR number, current constraint) — clean up when done |

### When to use which

- **Before writing to memory:** ask "will this still be useful three sessions from now?" If yes → active block or Serena. If no → journal.
- **Avoid bloating active blocks.** If a note needs a full paragraph or example, put it in Serena or the journal.
- **`current` is temporary.** Use `memory_replace` (not append) when updating it; clear it when the task is done.
- **Journal for history.** One-off bug investigations, research findings, version notes → journal with appropriate tag (`debugging`, `research`, `decision`, etc.).

### Serena memory

- Store decisions, learned conventions, and non-obvious config choices in
  Serena memories (`serena_write_memory`).
- The `.serena/` directory is committed to git — memories persist across
  machines.
- Memory names: use `/` to organize by topic, e.g.
  `decisions/git_mcp_wrapper_bun_2026-03-27`.
- Prefer Serena over active blocks when the context is project-specific and
  paragraph-level (too verbose for the always-injected window).
