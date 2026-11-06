# OpenCode Dotfiles — Complete Multi-Machine Replication

This repository contains a portable, self-documenting OpenCode configuration that can be replicated across any number of machines (Linux, macOS, WSL) with minimal manual steps.

**Target audience:** You (the maintainer) + any collaborator who wants the exact same AI coding environment.

---

## 🎯 What This Replicates

| Layer | What's Included | Portability |
|-------|-----------------|-------------|
| **Global Server Config** (`opencode.jsonc`) | Plugins, MCP servers, LSPs, permissions | ✅ Fully portable (uses `{env:HOME}`) |
| **CLI/TUI Preferences** (`cli.json`) | Theme, keybindings, diffs, animations | ✅ Fully portable |
| **Skills** (`skills/`) | `manage-mcps`, `manage-skills` | ✅ Symlinked |
| **Plugins** | `superpowers` (git), `@dietrichgebert/ponytail` | ✅ Auto-loaded from config |
| **MCP Servers** | GitHub (OAuth), Playwright, Fetch, Filesystem, Memory, Docker, Kubernetes (disabled), Postgres (disabled), MySQL (disabled) | ✅ Config portable; OAuth re-auth per machine |
| **LSPs** | TypeScript, JSON, CSS, HTML, Tailwind, ESLint, Pyright, gopls, rust-analyzer | ✅ Config portable; binaries installed per machine |

### ⚠️ What's NOT Replicated (Intentional)

| Item | Why | How to Handle |
|------|-----|---------------|
| `service.json` | Contains machine-specific service auth token | **Generated fresh per machine** (recommended) |
| `~/.local/share/opencode/` | Sessions, logs, DB, tool output — per-machine state | Never replicate |
| `node_modules/` | `npx` fetches on demand | Not needed |
| **rea MCP** | Requires manual binary install + setup | Documented in [rea Setup](#-rea-manual-setup-per-machine) |
| OAuth tokens (GitHub) | Per-account, per-machine | Sign in via `/mcps` on each machine |
| Project-level `.opencode/` configs | Project-specific, live in project repos | Not in this repo |

---

## 🚀 Quick Start (New Machine)

```bash
# 1. Prerequisites (one-time)
#    - Node.js 18+ (nvm recommended: https://github.com/nvm-sh/nvm)
#    - Git
#    - Optional: Go (for gopls), Rust (for rust-analyzer), Python (for pyright)

# 2. Clone and link
git clone <THIS_REPO_URL> ~/dotfiles
rm -rf ~/.config/opencode
ln -s ~/dotfiles/opencode ~/.config/opencode

# 3. Generate service auth token & start background service
opencode service restart
opencode service status
# Should show: {"status":"running","pid":...}

# 4. Launch OpenCode TUI and complete OAuth
opencode
# Inside TUI: Ctrl+P → type "/mcps" → Enter → select "github" → "Sign in"
# Other MCPs (playwright, fetch, filesystem, memory, docker) connect automatically

# 5. Verify everything works
# In TUI: type a prompt → should see tools available
# Check MCPs: /mcps → all should show "connected" (except disabled ones)
```

**Total time:** ~3 minutes (plus OAuth flow).

---

## 🤖 For AI Agents — One-Prompt Setup

Paste this prompt into any agent to fully bootstrap OpenCode on a new machine end-to-end. The agent clones the repo, reads `agents/bootstrap-new-machine.md`, follows every step, and handles everything except manual interactive steps (OAuth sign-in, optional rea setup):

```
I've cloned this repo to ~/dotfiles. Read `agents/bootstrap-new-machine.md` and execute every step exactly in order. After each step, verify it worked before continuing. If something fails, report the error and ask how to fix it — don't skip ahead. For the GitHub OAuth step (Step 5), output the exact manual instructions and wait for human confirmation before proceeding. For any optional tools (like rea), output install commands and wait for human confirmation. At the end, run the verification checklist (Step 7) and report a summary of successes, failures, and remaining manual steps needed. Do not skip any steps.
```

Then run this script to automate the non-interactive parts (clone, symlink, service restart, LSP installs). After running it, you'll still need to complete the GitHub OAuth manually and optionally install rea:

```bash
./scripts/bootstrap.sh
```

This leaves you two manual actions:
1. **GitHub OAuth** — inside `opencode` TUI, press Ctrl+P → /mcps → select github → Sign in
2. **rea setup** (optional) — install `rea` then run `rea mcp`, or add the config block below to `~/.config/opencode/opencode.jsonc`:

```jsonc
"rea": {
  "type": "local",
  "command": ["npx", "-y", "@rea/rea"],
  "enabled": true
}
```

---

## 📋 Detailed Step-by-Step Walkthrough

### Step 1: Install Prerequisites

#### Required
```bash
# Node.js 18+ (via nvm - recommended for version management)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
source ~/.bashrc  # or ~/.zshrc
nvm install --lts
nvm use --lts

# Git
# Usually pre-installed; if not:
# Ubuntu/Debian: sudo apt install git
# macOS: xcode-select --install
# Fedora: sudo dnf install git
```

#### Optional (for LSPs)
```bash
# Go (for gopls) - choose one:
#   Ubuntu/Debian: sudo apt install golang-go
#   macOS: brew install go
#   Or: https://go.dev/dl/ (manual)
# After install: go install golang.org/x/tools/gopls@latest

# Rust (for rust-analyzer) - via rustup:
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
source ~/.cargo/env
rustup component add rust-analyzer

# Python (for pyright) - usually pre-installed
# pip install pyright  # or: npx handles it
```

> **Note:** LSPs will show "disconnected" if their binaries aren't on PATH. This doesn't break OpenCode — you just won't get language features for those languages.

---

### Step 2: Clone and Link Configuration

```bash
# Clone your dotfiles repo (replace with your actual URL)
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/dotfiles

# Replace any existing OpenCode config with symlink
rm -rf ~/.config/opencode
ln -s ~/dotfiles/opencode ~/.config/opencode

# Verify the symlink
ls -la ~/.config/opencode
# Should show: opencode -> /home/USER/dotfiles/opencode
```

> **Why symlink?** Changes on any machine automatically sync to the repo. `git pull` on other machines picks them up instantly.

---

### Step 3: Generate Service Auth Token

```bash
opencode service restart
# Output: Service restarted successfully

opencode service status
# Expected:
# {
#   "status": "running",
#   "pid": 12345,
#   "port": 4096,
#   "version": "0.x.x"
# }
```

**What this does:** Creates a fresh `~/.config/opencode/service.json` with a unique random password. The background service handles sessions, tool execution, and MCP connections.

> **Do not commit `service.json` to the repo.** Each machine must have its own. If you accidentally commit it, regenerate: `opencode service restart`.

---

### Step 4: Launch & Complete OAuth

```bash
opencode
```

Inside the TUI:

1. Press `Ctrl+P` → type `/mcps` → Enter
2. You'll see a list of MCP servers. Find **github** → press Enter
3. Select **Sign in** → browser opens → authorize the GitHub app
4. Return to TUI — github should now show **Connected**

Other MCPs (playwright, fetch, filesystem, memory, docker) connect automatically on startup. Disabled ones (kubernetes, postgres, mysql) show **Disabled**.

---

### Step 5: Verify Full Functionality

In the OpenCode TUI:

```bash
# Test basic chat
> Hello, what tools do you have available?

# Test filesystem MCP
> List files in my home directory

# Test GitHub MCP (requires OAuth)
> Show my GitHub repositories

# Test playwright MCP
> Take a screenshot of example.com

# Check skills are loaded
> What skills do I have?
# Should mention: manage-mcps, manage-skills
```

---

## 🔧 Per-Machine Configuration

### Environment Variables (Required)

Add these to your shell profile (`~/.bashrc`, `~/.zshrc`, `~/.config/fish/config.fish`):

```bash
# GitHub MCP (required for GitHub operations)
export GITHUB_TOKEN="ghp_xxxxxxxxxxxxxxxxxxxx"  # Personal Access Token with repo scope
# OR use GitHub CLI: gh auth token (if gh is installed)

# Optional: Enable Postgres MCP
# export POSTGRES_URL="postgresql://user:pass@host:5432/db"

# Optional: Enable MySQL MCP
# export MYSQL_HOST="localhost"
# export MYSQL_PORT="3306"
# export MYSQL_USER="root"
# export MYSQL_PASSWORD="password"
# export MYSQL_DATABASE="mydb"

# Optional: Override LSP paths if not in standard locations
# export GOPLS_PATH="/custom/path/gopls"
# export RUST_ANALYZER_PATH="/custom/path/rust-analyzer"
```

> **How to get GitHub token:** GitHub Settings → Developer settings → Personal access tokens → Tokens (classic) → Generate new token → select `repo` scope.

---

### LSP Binary Paths (Automatic if Standard)

The config uses `{env:HOME}` interpolation for portability:

```jsonc
"gopls": { "command": ["{env:HOME}/go/bin/gopls"] },
"rust-analyzer": { "command": ["{env:HOME}/.cargo/bin/rust-analyzer"] }
```

If you installed Go/Rust in non-standard locations, either:

1. **Symlink to standard location:**
   ```bash
   mkdir -p ~/go/bin
   ln -s /actual/path/to/gopls ~/go/bin/gopls
   ```

2. **Or set env var in shell profile:**
   ```bash
   export GOPLS_PATH="/actual/path/gopls"
   # Then update opencode.jsonc to use {env:GOPLS_PATH} instead
   ```

---

### rea (Reverse Engineering Assistant) — Manual Setup Per Machine

**rea is intentionally NOT in the replicated config** because it requires a native binary install that varies by platform.

#### Option A: Run Ad-Hoc (Recommended for Occasional Use)
```bash
# Install rea (check https://github.com/rea/rea for latest)
# Then run MCP server in a separate terminal/tmux pane:
rea mcp

# In OpenCode, it will auto-discover if running on default port
# Or add temporarily via /mcps → "Add server" → local → command: ["rea", "mcp"]
```

#### Option B: Add Permanently to Your Config
After installing rea, edit `~/.config/opencode/opencode.jsonc` (your local symlinked copy):

```jsonc
"mcp": {
  // ... existing servers ...
  "rea": {
    "type": "local",
    "command": ["npx", "-y", "@rea/rea"],
    "enabled": true
  }
}
```

> **Note:** The repo's `opencode.jsonc` includes a commented template for this.

---

## 🔄 Updating the Config Across Machines

### Making Changes

1. On any machine, edit files in `~/.config/opencode/` (they're symlinked to the repo):
   ```bash
   # Edit global config
   $EDITOR ~/.config/opencode/opencode.jsonc
   
   # Edit CLI prefs
   $EDITOR ~/.config/opencode/cli.json
   ```

2. Changes to `.jsonc`/`.json` files **auto-reload** (no restart needed for most changes).

3. Commit and push:
   ```bash
   cd ~/dotfiles
   git add -A
   git commit -m "Update: describe your change"
   git push
   ```

### Pulling Changes on Other Machines

```bash
cd ~/dotfiles && git pull

# Most changes apply immediately. For structural changes:
opencode service restart
```

---

## 🧪 Troubleshooting

### Service Won't Start

```bash
# Check logs
cat ~/.local/share/opencode/log/opencode.log | grep -i error

# Force restart
opencode service restart

# Nuclear option: stop, remove socket, restart
opencode service stop
rm -f ~/.local/share/opencode/socket
opencode service restart
```

### MCP Shows "Disconnected"

```bash
# 1. Restart service
opencode service restart

# 2. Check /mcps in TUI for specific error

# 3. Common fixes:
# - GitHub: Re-run OAuth (/mcps → github → Sign in)
# - Filesystem: Verify {env:HOME} expands correctly (echo $HOME)
# - Docker: Ensure docker daemon running (docker ps)
# - Playwright: npx playwright install (first run)
```

### LSP Not Connecting

```bash
# Check binary exists
ls -la ~/go/bin/gopls
ls -la ~/.cargo/bin/rust-analyzer

# Install if missing
go install golang.org/x/tools/gopls@latest
rustup component add rust-analyzer

# Verify on PATH
which gopls
which rust-analyzer

# Restart service after install
opencode service restart
```

### Config Not Reloading

```bash
# Force full reload in TUI
/reload

# Or restart service
opencode service restart
```

### Skills Not Loading

```bash
# Verify skills dir exists
ls ~/.config/opencode/skills/

# Should show: manage-mcps/  manage-skills/

# Restart service
opencode service restart
```

### "Permission Denied" on Symlink

```bash
# If ~/.config/opencode exists and is owned by root:
sudo rm -rf ~/.config/opencode
ln -s ~/dotfiles/opencode ~/.config/opencode
```

---

## 📁 Repository Structure

```
dotfiles/
├── opencode/
│   ├── opencode.jsonc          # Global server config (main file)
│   ├── cli.json                # CLI/TUI preferences
│   ├── skills/
│   │   ├── manage-mcps/        # Skill: browse/install MCP servers from mcpservers.org
│   │   │   └── SKILL.md
│   │   └── manage-skills/     # Skill: browse/install skills from skills.sh
│   │       └── SKILL.md
│   └── (no service.json)      # Generated per machine
├── agents/                     # AI agent bootstrap instructions
│   └── bootstrap-new-machine.md  # Self-contained agent checklist for new machines
├── scripts/                   # Automation scripts
│   └── bootstrap.sh            # Non-interactive setup script (skip interactive parts)
├── README.md                  # This file
└── .gitignore                  # Excludes service.json, node_modules, etc.
```

### Key Files Explained

| File | Purpose |
|------|---------|
| `opencode.jsonc` | All server-side config: plugins, MCPs, LSPs, permissions. Uses `{env:VAR}` for portability. |
| `cli.json` | Terminal UI preferences: theme, diffs, tabs, animations, keybindings. |
| `skills/manage-mcps/` | Skill for discovering/adding MCP servers from mcpservers.org. |
| `skills/manage-skills/` | Skill for discovering/installing skills from skills.sh. |

---

## 🛡️ Security Notes

| Secret | Where It Lives | Rotation |
|--------|----------------|----------|
| Service auth token | `~/.config/opencode/service.json` (per machine) | `opencode service restart` |
| GitHub token | `GITHUB_TOKEN` env var (per machine) | GitHub Settings → PAT |
| Postgres/MySQL URLs | Env vars (per machine) | Rotate DB credentials |
| rea (if used) | Local binary + config | N/A |

**Never commit:**
- `service.json`
- Actual API keys/tokens in config files (use `{env:VAR}` interpolation)
- `~/.local/share/opencode/` contents

---

## 🎨 Customization Guide

### Adding a New MCP Server

```bash
# Option 1: Use the skill (interactive)
# In OpenCode: "Add an MCP server for PostgreSQL"

# Option 2: Manual edit
$EDITOR ~/.config/opencode/opencode.jsonc
# Add to "mcp" object:
"new-server": {
  "type": "local",
  "command": ["npx", "-y", "@package/mcp-server"],
  "enabled": true,
  "environment": {
    "API_KEY": "{env:MY_API_KEY}"
  }
}
```

Then: `cd ~/dotfiles && git add -A && git commit -m "Add new-server MCP" && git push`

### Adding a New Skill

```bash
# Install from skills.sh
npx skills add owner/repo/skill-name

# This adds to ~/.config/opencode/skills/ (symlinked to repo)
# Commit the new skill directory
```

### Changing Theme/Keybindings

```bash
$EDITOR ~/.config/opencode/cli.json
# Modify theme.name, keybinds, diffs, etc.
# Auto-reloads in TUI
```

---

## 📦 What's Installed by Default

### Plugins (from `opencode.jsonc`)
- **superpowers** — Advanced agent orchestration, planning, debugging tools
- **ponytail** — Lazy senior dev mode: minimal changes, YAGNI enforcement

### MCP Servers
| Server | Type | Purpose | Auth |
|--------|------|---------|------|
| github | local (npx) | GitHub API: repos, issues, PRs, search | OAuth (per machine) |
| playwright | local (npx) | Browser automation, screenshots | None |
| fetch | local (npx) | HTTP fetching, web scraping | None |
| filesystem | local (npx) | File read/write/list in `{env:HOME}` | None |
| memory | local (npx) | Persistent key-value memory | None |
| docker | local (npx) | Docker container/volume/image mgmt | Docker socket |
| kubernetes | local (npx) | K8s cluster management | kubeconfig (disabled) |
| postgres | local (npx) | PostgreSQL queries | `POSTGRES_URL` (disabled) |
| mysql | local (npx) | MySQL queries | `MYSQL_*` env vars (disabled) |

### LSPs (Language Servers)
| Language | Server | Install Command |
|----------|--------|-----------------|
| TypeScript/JS | typescript-language-server | `npm i -g typescript-language-server` (npx handles) |
| JSON/JSONC | vscode-json-language-server | npx |
| CSS/SCSS | vscode-css-language-server | npx |
| HTML | vscode-html-language-server | npx |
| Tailwind | tailwindcss-language-server | npx |
| ESLint | vscode-eslint-language-server | npx |
| Python | pyright | `pip install pyright` or npx |
| Go | gopls | `go install golang.org/x/tools/gopls@latest` |
| Rust | rust-analyzer | `rustup component add rust-analyzer` |

---

## 🌍 Platform-Specific Notes

### Linux (Ubuntu/Debian/Fedora/Arch)
- All tools work natively
- Docker: ensure user in `docker` group (`sudo usermod -aG docker $USER`)
- systemd: OpenCode service runs as user process

### macOS
- Use Homebrew for prerequisites: `brew install node git go rust`
- Docker: Docker Desktop required
- LaunchAgent: not needed; service runs on demand

### WSL2 (Windows)
- Use Linux instructions inside WSL
- Docker: Docker Desktop with WSL integration
- File paths: `{env:HOME}` resolves to `/home/user` (Linux side)
- Windows files: access via `/mnt/c/...` if needed

---

## 🤝 For Collaborators / Other Users

If you want to use this exact setup:

1. **Fork this repo** to your own GitHub/GitLab
2. **Follow Quick Start** above with your fork URL
3. **Customize** by editing `opencode.jsonc` and `cli.json`
4. **Push changes** to your fork
5. **Sync across your machines** with `git pull`

### Minimal Customization Checklist

- [ ] Set `GITHUB_TOKEN` in shell profile
- [ ] Install Go/Rust if you want those LSPs
- [ ] Set up rea if you need reverse engineering
- [ ] Enable postgres/mysql MCPs if needed (set env vars)
- [ ] Adjust `cli.json` theme/keybindings to taste

---

## 📚 References

- **OpenCode Docs:** https://opencode.ai/v2/docs/
- **Configuration Reference:** https://opencode.ai/v2/docs/config
- **MCP Servers:** https://opencode.ai/v2/docs/mcp-servers
- **CLI Settings:** https://opencode.ai/v2/docs/cli/config
- **Skills:** https://opencode.ai/v2/docs/skills
- **Plugins:** https://opencode.ai/v2/docs/build/plugins
- **mcpservers.org:** https://mcpservers.org
- **skills.sh:** https://skills.sh
- **superpowers:** https://github.com/obra/superpowers
- **ponytail:** https://github.com/dietrichgebert/ponytail

---

## 📝 License / Attribution

This configuration is tailored for personal/team use. Individual components have their own licenses:
- OpenCode: Apache-2.0
- superpowers: MIT
- ponytail: MIT
- MCP servers: Various (check each package)

Feel free to fork, adapt, and share.

---

## ✅ Verification Checklist (New Machine)

After setup, verify each item:

- [ ] `opencode service status` → `"status": "running"`
- [ ] `opencode` launches TUI without errors
- [ ] `/mcps` → github shows **Connected** (after OAuth)
- [ ] `/mcps` → playwright, fetch, filesystem, memory, docker show **Connected**
- [ ] `/mcps` → kubernetes, postgres, mysql show **Disabled** (unless enabled)
- [ ] Skills loaded: "manage-mcps", "manage-skills" available
- [ ] LSPs: TypeScript, JSON, CSS, HTML, Tailwind, ESLint, Pyright show **Connected**
- [ ] LSPs: gopls, rust-analyzer show **Connected** (if Go/Rust installed)
- [ ] File operations work: "List files in ~/"
- [ ] GitHub operations work: "Show my repos"
- [ ] Theme/keybindings from `cli.json` applied

---

**Happy coding! 🎉** — This setup gives you a consistent, powerful AI-assisted development environment everywhere you work.