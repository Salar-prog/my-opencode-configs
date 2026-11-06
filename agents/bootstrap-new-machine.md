# OpenCode New Machine Bootstrap — Agent Instructions

Use this file to set up OpenCode on a fresh machine. Execute every step in order, verify after each step, and stop to ask if any prerequisite is missing.

---

## Prerequisites (required before starting)

| Tool | Check Command | Install If Missing |
|------|---------------|-------------------|
| Node.js | `node --version` | `nvm install --lts` |
| Git | `git --version` | OS package manager |
| OpenCode | `which opencode` | `npm install -g @opencode-ai/opencode` |
| OpenAI-style API key | `echo $OPENAI_API_KEY` | Set in shell profile |

Optional (for LSPs):
| Tool | Check Command | Install If Missing |
|------|---------------|-------------------|
| Go + gopls | `which gopls` | `go install golang.org/x/tools/gopls@latest` |
| Rust + rust-analyzer | `which rust-analyzer` | `rustup component add rust-analyzer` |
| Python | `python3 --version` | OS package manager |

---

## Step 1: Clone the Git Repo

```bash
# Replace with your fork URL if you forked this repo
REPO_URL="https://github.com/Salar-prog/my-opencode-configs.git"

if [ ! -d ~/dotfiles ]; then
  git clone "$REPO_URL" ~/dotfiles
else
  cd ~/dotfiles && git pull
fi

cd ~/dotfiles
```

**Verify:** `ls ~/dotfiles/opencode/opencode.jsonc` — should exist.

---

## Step 2: Link OpenCode Config

```bash
rm -rf ~/.config/opencode
ln -s ~/dotfiles/opencode ~/.config/opencode
```

**Verify:** `ls -la ~/.config/opencode` — should show symlink `opencode -> /home/USER/dotfiles/opencode`.

---

## Step 3: Generate Service Auth Token & Start Service

```bash
opencode service restart
opencode service status
```

**Expected output:** `"status": "running"` with a PID.

**Verify:** `cat ~/.config/opencode/service.json` — should contain a freshly generated password.

---

## Step 4: Install Global Skills (already bundled)

The repo includes `skills/manage-mcps/` and `skills/manage-skills/`. Because `~/.config/opencode` is symlinked to `~/dotfiles/opencode`, these skills are already in place.

**Verify:** `ls ~/.config/opencode/skills/` — should show `manage-mcps` and `manage-skills`.

---

## Step 5: Launch OpenCode & Complete GitHub OAuth

```bash
opencode
```

Inside the TUI:
1. Press `Ctrl+P`, type `/mcps`, press Enter
2. Select **github** → **Sign in**
3. Browser opens → authorize the GitHub app
4. Return to TUI — github should show **Connected**

Other MCPs (playwright, fetch, filesystem, memory, docker) connect automatically.

> ⚠️ **Manual step:** GitHub OAuth requires a human to click through the browser. The agent cannot complete this automatically. Output the exact instructions and wait for confirmation.

---

## Step 6: Install LSP Binaries (if available)

If Go or Rust are installed, ensure the LSPs are available:

```bash
# Go / gopls
if which go >/dev/null 2>&1; then
  go install golang.org/x/tools/gopls@latest
fi

# Rust / rust-analyzer
if which rustup >/dev/null 2>&1; then
  rustup component add rust-analyzer
fi
```

These install to `~/go/bin/gopls` and `~/.cargo/bin/rust-analyzer`, matching the `{env:HOME}/...` paths in `opencode.jsonc`.

**Verify:** `which gopls` and `which rust-analyzer` (if Go/Rust installed).

---

## Step 7: Verification Checklist

Run in the OpenCode TUI or via API:

```
[ ] opencode service status → "running"
[ ] opencode launches TUI without errors
[ ] /mcps → github Connected (after OAuth)
[ ] /mcps → playwright Connected
[ ] /mcps → fetch Connected
[ ] /mcps → filesystem Connected
[ ] /mcps → memory Connected
[ ] /mcps → docker Connected
[ ] /mcps → kubernetes Disabled (expected)
[ ] /mcps → postgres Disabled (expected)
[ ] /mcps → mysql Disabled (expected)
[ ] /mcps → skills loaded: manage-mcps, manage-skills
[ ] LSPs connected: typescript, json, css, html, tailwind, eslint, pyright
[ ] LSPs connected: gopls, rust-analyzer (if Go/Rust installed)
[ ] Filesystem test: "List files in ~/" → works
[ ] GitHub test: "Show my GitHub repositories" → works (after OAuth)
```

---

## Step 8: Report

Output:
- Steps that succeeded
- Steps that failed (with error messages)
- Manual actions needed: GitHub OAuth (if not done), rea setup (optional)
- Whether `opencode service status` shows running

---

## Optional: rea Setup (Manual, Per Machine)

```bash
# Install rea (check https://github.com/rea/rea for latest install instructions)
# Then run:
rea mcp
```

Add to `~/.config/opencode/opencode.jsonc` (your local symlinked copy):

```jsonc
"rea": {
  "type": "local",
  "command": ["npx", "-y", "@rea/rea"],
  "enabled": true
}
```

---

## Environment Variables (set in shell profile)

Add to `~/.bashrc`, `~/.zshrc`, or equivalent:

```bash
export GITHUB_TOKEN="ghp_xxx"          # GitHub MCP — Personal Access Token with repo scope
# export POSTGRES_URL="postgresql://..." # If enabling postgres MCP
# export MYSQL_HOST="..."                # If enabling mysql MCP
# export MYSQL_PORT="3306"
# export MYSQL_USER="..."
# export MYSQL_PASSWORD="..."
# export MYSQL_DATABASE="..."
```

---

Done. OpenCode is ready to use on this machine.
