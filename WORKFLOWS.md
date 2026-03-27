# Workflows — Practice Cheatsheet

Quick reference for all automation workflows in this dotfiles setup.

---

## 1. Start/End of Day — Repo Sync

**What it does**: Pulls all git repos under `~/dev` in parallel.

**How to trigger**:
```
sr
```
(abbreviation for `sync-repos`)

**What to expect**: Each repo shows `[repo-name] Already up to date.` or `[repo-name] Fast-forward …`. All repos run concurrently; output appears as each finishes.

**Tweak suggestions**:
- Add `~/projects` dir: edit `sync-repos.fish`, change `find ~/dev` to `find ~/dev ~/projects`
- Increase scan depth: change `-maxdepth 2` to `-maxdepth 3`
- Add push step for EOD: append `git push` after `git pull --rebase`

---

## 2. Navigate Tmux Panes + Neovim Splits

**What it does**: Ctrl+h/j/k/l moves seamlessly between tmux panes and neovim splits — no mode switching needed.

**How to trigger**:
| Key | Action |
|-----|--------|
| `Alt+h` | Move left |
| `Alt+j` | Move down |
| `Alt+k` | Move up |
| `Alt+l` | Move right |
| `prefix + \|` | New vertical split |
| `prefix + -` | New horizontal split |
| `S-Left / S-Right` | Previous/next window |

**What to expect**: Cursor moves across pane/split boundary without any prefix key.

**Tweak suggestions**:
- If `Alt+l` conflicts with a terminal keybind, remap to `prefix + h/j/k/l` instead

---

## 3. Open Lazygit

**What it does**: Opens lazygit in an interactive TUI for staging, committing, pushing, branching.

**How to trigger**:
- From neovim: `<leader>gg`
- From fish shell: `lg` (alias for `lazygit`)

**What to expect**: Full-screen lazygit panel opens. In neovim it opens as a floating terminal.

**Key lazygit bindings**:
| Key | Action |
|-----|--------|
| `?` | Help |
| `space` | Stage/unstage file |
| `c` | Commit |
| `P` | Push |
| `p` | Pull |
| `b` | Branch menu |
| `q` | Quit |

---

## 4. Share Code Link (GitHub / Bitbucket)

**What it does**: Generates a permalink to the current file + line number and either copies it or opens it in the browser.

### In Neovim

**How to trigger**:
| Key | Action |
|-----|--------|
| `<leader>go` | Open current file/line in browser |
| `<leader>gL` | Copy permalink to clipboard |

Works in normal mode (current line) and visual mode (selected range).

**What to expect**: Browser opens to `github.com/.../blob/abc123/path/to/file.lua#L42`.

### In Terminal

**How to trigger**:
```
git-open
```
Or from tmux: `prefix + o` (runs `git-open` in current pane's directory)

**What to expect**: Browser opens to the repo root on GitHub/Bitbucket.

**Tweak suggestions**:
- Add branch support to `git-open.fish` for branch-specific URLs
- Map `<leader>gB` to open the repo root (not current file)

---

## 5. Switch K8s Context + Launch k9s

**What it does**: Shows all kubectl contexts in fzf picker, switches to selected context, then launches k9s.

**How to trigger**:
```
kc
```
(abbreviation for `kctx`)

**What to expect**: fzf opens with list of contexts. Select one → `Switched to context "…"` → k9s opens automatically.

**Key k9s bindings**:
| Key | Action |
|-----|--------|
| `:ns` | Switch namespace |
| `/` | Filter resources |
| `ctrl+d` | Describe resource |
| `l` | View logs |
| `d` | Delete resource |
| `ctrl+c` | Quit |

**Tweak suggestions**:
- Skip k9s auto-launch: remove the `and k9s` line in `cloud-connect.fish`
- Add namespace pre-selection after context switch

---

## 6. AWS Profile Login

**What it does**: Shows all AWS profiles from `~/.aws/config` in fzf picker, runs `aws sso login` for selected profile.

**How to trigger**:
```
al
```
(abbreviation for `aws-login`)

**What to expect**: fzf opens with all profile names. Select one → `Logging in to profile: my-profile` → browser opens for SSO login.

**Verify login**:
```
aws sts get-caller-identity --profile my-profile
```

**Tweak suggestions**:
- Auto-export `AWS_PROFILE` after login: add `set -gx AWS_PROFILE $profile` in `cloud-connect.fish`
- Show current profile in tide prompt: tide already has an `aws` item — enable it in `_tide_init.fish`

---

## 7. Work Dotfiles Layer (on work machine)

**What it does**: Applies a work-specific overlay on top of personal dotfiles — separate name/email, work aliases, work tools — without touching the personal repo.

**Architecture**:
```
work-dotfiles/
├── personal/           # git submodule → this personal repo
├── fish/
│   └── .config/fish/conf.d/
│       ├── work-aliases.fish
│       └── work-abbr.fish
├── git/
│   └── .gitconfig.local    # stowed to ~/.gitconfig.local
└── install.sh
```

**How to set up on work machine**:
```bash
git clone <work-dotfiles-repo> ~/work-dotfiles
cd ~/work-dotfiles
git submodule update --init
./install.sh               # 1) personal stow.sh  2) work stow.sh
```

**How it works**:
- `~/.gitconfig` includes `~/.gitconfig.local` (already wired via `[include]`)
- Fish auto-sources all `conf.d/*.fish` — work files are picked up automatically
- Personal and work layers are fully independent repos

---

## 8. Domain Workspace — Multi-Repo Development

**What it does**: Organises related services (a "domain") into a structured nvim + tmux workspace with cross-repo search and per-repo AI context.

**Concept**:
A domain is a group of related repos (microservices, infra modules, shared libs) that need to be worked on together.

```
~/dev/<domain>/          ← e.g. ~/dev/payments, ~/dev/platform, ~/dev/data
├── CLAUDE.md            ← inter-repo architecture: how services relate, API contracts, data flows
├── service-a/
│   └── CLAUDE.md        ← what this service does, its dependencies, key entry points
├── service-b/
│   └── CLAUDE.md
└── shared-lib/
    └── CLAUDE.md
```

**Tmux layout**:
```
Window: <domain>         → nvim ~/dev/<domain>   (cross-repo search, Claude with full domain context)
Window: service-a        → nvim ~/dev/<domain>/service-a  (focused work, LSP, Claude per-repo)
Window: service-b        → nvim ~/dev/<domain>/service-b
```

**How to trigger**:
- Name tmux window: `prefix + ,`
- Open domain window: `nvim ~/dev/<domain>`
- Switch to focused repo window: `Shift+Left/Right`
- Cross-repo search: `<leader>ff` or `<leader>/` (telescope searches from domain root)
- Per-repo search: navigate to a file in that repo first — `project.nvim` auto-switches cwd to its git root

**AI context (Claude)**:
- From domain window: Claude reads parent `CLAUDE.md` → understands how services relate
- From service window: Claude reads repo `CLAUDE.md` → focused, precise context
- Rule of thumb: architecture questions → domain window, implementation → service window

**Tweak suggestions**:
- Add `~/dev/<domain>/CLAUDE.md` describing data flows and service boundaries first — this is the highest-value doc to write
- Use `sr` (sync-repos) to pull all services at start of day

---

## Theme Overview

All tools share **Catppuccin Mocha** dark theme:

| Tool | Config |
|------|--------|
| Ghostty | `theme = catppuccin-mocha` (dark) / `catppuccin-latte` (light, auto-switch) |
| Tmux | Inline Mocha colors in `.tmux.conf` status bar |
| Neovim | `catppuccin/nvim` plugin, `flavour = "mocha"` |

---

## Verification Checklist

After fresh setup, verify each workflow:

- [ ] `tmux` → `prefix + I` → plugins install → `Ctrl+h/j/k/l` navigates panes
- [ ] `nvim` opens with Catppuccin Mocha (matches ghostty + tmux)
- [ ] `<leader>gg` → lazygit opens in nvim float
- [ ] `<leader>go` → browser opens to current file/line on GitHub or Bitbucket
- [ ] `sr` → pulls all `~/dev` repos in parallel with per-repo status
- [ ] `al` → fzf profile picker → `aws sso login` runs
- [ ] `kc` → fzf context picker → k9s launches
- [ ] `git-open` in terminal or `prefix+o` in tmux → browser opens repo
