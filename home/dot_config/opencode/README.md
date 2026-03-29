# OpenCode Global Config

Personal global configuration for [OpenCode](https://opencode.ai), loaded from `~/.config/opencode/` on every session.

---

## Folder structure

```
~/.config/opencode/
├── opencode.jsonc          # Main config (models, MCP, permissions, formatters, plugins)
├── dcp.jsonc               # DCP plugin config (context pruning)
├── AGENTS.md               # Agent conventions and code style rules (loaded by every session)
├── opencode-notifier.json  # Config for @mohak34/opencode-notifier (sound, system, suppress rules)
├── opencode-notifier-state.json  # Auto-managed by opencode-notifier plugin (tracks last notified turn)
├── tsconfig.json           # TypeScript config (strict, noEmit, bun-types, bundler resolution)
├── package.json            # Bun package (plugin SDK + bun-types + typescript dev deps)
├── agents/                 # Custom agent definitions (code, debug, docs, review, scout)
├── command/                # Custom slash commands (plannotator-*)
├── scripts/
│   ├── git-mcp-wrapper.ts  # Bun/TS — smart proxy for mcp-server-git (repo-aware)
│   └── opencode-start.sh   # sh — startup wrapper: refresh shell_strategy.md, then exec opencode
└── plugins/
    └── shell-strategy/     # Vendored runtime file only (auto-refreshed by startup wrapper)
        └── shell_strategy.md  # Injected as a global instruction file
```

---

## Models & default agent

| Setting | Value |
|---|---|
| Default model | `openai/gpt-5.3-codex` |
| Small model | `openai/gpt-5.4-mini` |
| Plan agent model | `openai/gpt-5.4` |
| Default agent | `code` |
| Autoupdate | `notify` / Share: `disabled` / Snapshots: enabled |

Disabled providers: `ollama-cloud`, `openrouter`, `google`.

---

## Permissions

Bash defaults to **ask**. Explicit allows cover routine operations:

| Allowed without prompt | Ask | Denied |
|---|---|---|
| `git status/diff/log/add/commit/checkout/branch/stash/pull/push/fetch/show` | `cat *`, `find *`, `grep *` | Edit `**/.env*` |
| `npm install/run/test/ci/list *` | — | — |
| `npx prettier/tsc/phpstan/php-cs-fixer *` | — | — |
| `node *`, `bun *`, `ls *` | — | — |

Tasks run silently (`"task": "allow"`). Out-of-project access and doom-loop detection prompt with `ask`.

---

## Formatters

Run automatically after edits — do not manually format.

| Formatter | Command | Extensions |
|---|---|---|
| **prettier** | `npx prettier --write $FILE` | ts, tsx, js, jsx, json, jsonc, css, scss, less, md, mdx, html, yaml, yml, graphql, gql, xml, svg |
| **pint** | `./vendor/bin/pint $FILE` | php |
| **prettier-blade** | npx + `@shufo/prettier-plugin-blade` | blade.php |
| **tailwind-sort** | npx + `prettier-plugin-tailwindcss` | blade.php, html, jsx, tsx, vue |

> `pint` only works inside a Laravel project (`./vendor/bin/pint` must exist). PHP edits elsewhere silently skip formatting.

---

## Plugins

| Plugin | Purpose |
|---|---|
| `@tarquinen/opencode-dcp` | Dynamic Context Pruning (see dcp.jsonc) |
| `opencode-vibeguard` | Safety review gates against vibe-coded changes |
| `cc-safety-net` | Blocks destructive commands |
| `opencode-snip` | Truncates large shell output to protect context |
| `opencode-pty` | PTY sessions for long-running processes |
| `@mohak34/opencode-notifier` | Desktop notifications on task completion |
| `@plannotator/opencode` | Plan annotation workflow (see `command/`) |
| `opencode-agent-memory` | Letta-style persistent memory blocks (persona, human, project) |
| `opencode-worktree` | Git worktree management |
| `@franlol/opencode-md-table-formatter` | Markdown table formatting |
| `opencode-claude-auth` | Uses Claude Code credentials — no separate login needed |

All pinned to `@latest` — fetched on startup.

---

## MCP servers

| Server | Type | Purpose |
|---|---|---|
| **serena** | local (uvx) | Symbol-level code navigation (find_symbol, references, rename) |
| **nixos** | local (uvx) | NixOS package and option search |
| **context7** | local (npx) | Up-to-date library and framework docs |
| **sequential-thinking** | local (npx) | Structured multi-step reasoning chains |
| **git** | local (bun) | Git operations via `scripts/git-mcp-wrapper.ts` |
| **grep-app** | remote | Search public GitHub repos for real-world code patterns |

### git MCP wrapper

`mcp-server-git` requires an explicit `--repository` path. `scripts/git-mcp-wrapper.ts` handles two cases:

- **Inside a git repo:** resolves the root via `git rev-parse --show-toplevel`, then exec-replaces itself with `uvx mcp-server-git --repository <root>`. Full tool set available.
- **Outside a git repo:** stays alive, reads the MCP handshake, and responds with `tools: []`. No error banners.

---

## LSP servers

| LSP | Command | Extensions |
|---|---|---|
| `fish-lsp` | `fish-lsp start` | `.fish` |
| `taplo` | `taplo lsp stdio` | `.toml` |
| `vscode-json-language-server` | `vscode-json-language-server --stdio` | `.json`, `.jsonc` |
| `marksman` | `marksman server` | `.md`, `.markdown` |

Install via mise or Homebrew — OpenCode does not manage these.

---

## DCP — Dynamic Context Pruning

Configured in `dcp.jsonc`. Compresses context when it grows too large.

| Setting | Value |
|---|---|
| Prune trigger | 75% of limit |
| Target after prune | 40% of limit |
| Turn protection | Last 10 turns |
| Nudge frequency | Every 4 iterations (threshold: 15) |
| Protected MCP tools | `serena`, `sequential-thinking`, `memory_list`, `memory_set`, `memory_replace` |
| Notification | `minimal` |

**Protected files** (never pruned): `**/opencode.jsonc`, `**/dcp.jsonc`, `**/.opencode/instructions.md`, `**/.serena/project.yml`, `**/.env`, `**/.env.*`

Strategies: deduplication, purge errors (last 4 turns only).

---

## Instruction sources

Injected globally on every session:

1. **`.opencode/instructions.md`** — project-local. Create per-project for stack-specific rules.
2. **`plugins/shell-strategy/shell_strategy.md`** — non-interactive shell strategy (flags, piping, banned commands).

---

## Custom agents (`agents/`)

| Agent | Purpose |
|---|---|
| `code` | Primary implementation — write, edit, refactor. Uses Serena + Context7 + git MCP. **Default.** |
| `debug` | Diagnose and fix bugs |
| `docs` | Write and update inline docs, READMEs, OpenAPI specs, changelogs |
| `review` | Code review |
| `scout` | Fast codebase search and pattern discovery |

Switch with `/agent <name>`.

---

## Custom slash commands (`command/`)

| Command | Purpose |
|---|---|
| `/plannotator-annotate` | Interactive annotation UI for a markdown file |
| `/plannotator-last` | Annotate the most recent plan |
| `/plannotator-review` | Review and score an annotated plan |

---

## Memory strategy

Two complementary memory systems are active in every session.

| Layer | Tool | What belongs here |
|---|---|---|
| **Active blocks** (`opencode-agent-memory`) | `memory_list`, `memory_set`, `memory_replace` | Short, durable rules injected into every context window |
| **Journal** (`opencode-agent-memory`) | `memory_set` with `#tag` | One-off findings, investigation history, decision rationale |
| **Serena** | `serena_write_memory` | Deep per-project context, architecture notes — loaded on demand |

### Active memory blocks

| Block | Scope | Content |
|---|---|---|
| `persona` | global | Stable agent behavior rules — concise, `read_only` |
| `human` | global | Stable collaboration preferences — concise, `read_only` |
| `current` | project | Short-lived task context — clean up when done |

Active blocks are injected into every session context window. Keep them short and durable. Use the journal or Serena for anything that needs paragraph-level detail or is session-specific.

### Journal tags

Configured in `agent-memory.json`:

| Tag | When to use |
|---|---|
| `decision` | Decisions worth remembering later |
| `debugging` | Bug investigations and root-cause notes |
| `gotcha` | Non-obvious pitfalls or caveats |
| `tooling` | Tool behavior, configuration, or workflow notes |
| `workflow` | Execution-process or collaboration workflow notes |
| `review` | Code review findings or follow-up patterns |
| `research` | Exploration and investigation findings |
| `plugin-update-check` | Periodic review of pinned plugin versions |

### Plugin version

`opencode-agent-memory` is pinned to `0.2.0` in `opencode.jsonc`. Check for updates periodically:

```sh
npm info opencode-agent-memory version
```

---

## Maintenance

### Startup wrapper (fish)

The launcher script lives in this repo:

```sh
~/.config/opencode/scripts/opencode-start.sh
```

A Fish function wrapping it is managed by chezmoi at:

```
~/.config/fish/functions/opencode.fish
```

This means every `opencode` call in Fish automatically runs the pre-start refresh. The chezmoi source is at `home/dot_config/fish/functions/opencode.fish`.

The wrapper:
- fetches upstream `shell_strategy.md` (max every 24h)
- writes only when content changed
- stores the last-check timestamp in `~/.cache/opencode-shell-strategy.last-check`
- fails open on network errors
- passes all args/flags through with `exec opencode "$@"`

### Fish completions

Fish completion is managed locally in this repo at:

```
~/.config/fish/completions/opencode.fish
```

It uses `opencode --get-yargs-completions` dynamically, so completion stays in sync with the installed OpenCode version.

This is a temporary local integration while upstream native multi-shell completion support is still tracked in `anomalyco/opencode#1515`.

### Force-refresh shell-strategy now

```sh
rm -f ~/.cache/opencode-shell-strategy.last-check
~/.config/opencode/scripts/opencode-start.sh --help
```

### Validate / sanity checks

```sh
npm info opencode-vibeguard version && npm info @tarquinen/opencode-dcp version
fish-lsp --version && taplo --version && marksman --version && bun --version && uvx --version

bunx tsc --noEmit                                               # type-check scripts/git-mcp-wrapper.ts

opencode mcp list                                               # all 6 servers: serena, nixos, context7, sequential-thinking, git, grep-app
cd ~/some-git-project && opencode mcp list                     # git MCP has tools
cd /tmp && opencode mcp list                                    # git MCP: 0 tools, no error
ls ~/.config/opencode/plugins/shell-strategy/shell_strategy.md      # shell-strategy file exists
```

---

## Troubleshooting

### git MCP: "connection closed" or error banner

`uvx` not installed or not on `$PATH`. Fix: `pip install uv` or `brew install uv`.

Confirm the wrapper runs:
```sh
bun "$HOME/.config/opencode/scripts/git-mcp-wrapper.ts"
# Should wait on stdin (Ctrl+C to exit)
```

### `mcp-server-git` not found / uvx fetch fails

Network issue or stale cache:
```sh
uvx mcp-server-git --help   # forces a fresh fetch
```

### shell-strategy instructions not loading

```sh
ls ~/.config/opencode/plugins/shell-strategy/shell_strategy.md
```

If missing, restore just the required runtime file:
```sh
mkdir -p ~/.config/opencode/plugins/shell-strategy
curl -fsSL https://raw.githubusercontent.com/JRedeker/opencode-shell-strategy/trunk/shell_strategy.md \
  -o ~/.config/opencode/plugins/shell-strategy/shell_strategy.md
```

### Permissions prompting too much

Only explicitly listed `npx` commands are allowed (prettier, tsc, phpstan, php-cs-fixer). Add others to `opencode.jsonc`:
```jsonc
"npx eslint *": "allow"
```
Ensure `"*": "ask"` is the **first** entry in the `"bash"` block to preserve the catch-all.

### Formatter not running

- **Prettier:** `npx prettier --version` to confirm availability.
- **Pint:** Only works inside Laravel — silently skips elsewhere (expected).
- **prettier-blade / tailwind-sort:** Warm the npx cache if offline:
  ```sh
  npx -y -p prettier -p @shufo/prettier-plugin-blade prettier --version
  ```

### Serena MCP not connecting

Cold start fetches via `uvx --from git+https://...` (can take 10–20 s). If it consistently fails:
```sh
uvx --from git+https://github.com/oraios/serena serena --help
```
Requires Python 3.10+ and network access.

### DCP pruning too aggressively

Raise `maxContextLimit`, add patterns to `protectedFilePatterns`, or increase `turnProtection.turns` in `dcp.jsonc`. Set `"enabled": false` to disable entirely (requires restart).
