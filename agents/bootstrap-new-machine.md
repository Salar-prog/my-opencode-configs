# OpenCode New Machine Bootstrap — Agent Instructions

Use this file to set up OpenCode on a fresh machine. Execute every step in order, verify after each step, and stop to ask if any prerequisite is missing.

> If you have NOT yet cloned this repo, do so right now:
> ```bash
> REPO_URL="https://github.com/Salar-prog/my-opencode-configs.git"
> git clone "$REPO_URL" ~/dotfiles
> ```
> If you already have it cloned, skip to the next step after verifying.

---

## Prerequisites (required before starting)

| Tool | Check Command | Install If Missing |
|------|---------------|-------------------|
| Node.js | `node --version` | `nvm install --lts && nvm use --lts` |
| Git | `git --version` | OS package manager |
| OpenCode | `which opencode` | `npm install -g @opencode-ai/opencode` |
| OpenAI-style API key | `echo $OPENAI_API_KEY` | Set in shell profile |

Optional (for LSPs):
| Tool | Check Command | Install If Missing |
|------|---------------|-------------------|
| Go + gopls | `which gopls` | `go install golang.org/x/tools/gopls@latest` |
| Rust + rust-analyzer | `which rustup` | `rustup component add rust-analyzer` |
| Python | `python3 --version` | OS package manager |

---

## Step 1: Verify Repo Cloned

```bash
if [ ! -d ~/dotfiles ]; then
  REPO_URL="https://github.com/Salar-prog/my-opencode-configs.git"
  git clone "$REPO_URL" ~/dotfiles
else
  cd ~/dotfiles && git pull
fi

ls ~/dotfiles/opencode/opencode.jsonc   # Should exist
```

---

## Step 2: Link OpenCode Config

```bash
rm -rf ~/.config/opencode
ln -s ~/dotfiles/opencode ~/.config/opencode

ls -la ~/.config/opencode   # Should show symlink → ~/dotfiles/opencode
```

---

## Step 3: Generate Service Auth Token & Start Service

```bash
opencode service restart
opencode service status
# Expected: {"status": "running", "pid": ...}

cat ~/.config/opencode/service.json   # Fresh password generated
```

---

## Step 4: Verify Skills Present

```bash
ls ~/.config/opencode/skills/
# Should show: manage-mcps/ manage-skills/
```

---

## Step 5: Launch OpenCode & Complete GitHub OAuth

```bash
opencode
```

Inside TUI:
1. Press `Ctrl+P`, type `/mcps`, Enter
2. Select **github** → **Sign in**
3. Browser opens → authorize GitHub app
4. Return — github should show **Connected**

> ⚠️ **Manual step.** Output exact instructions and wait for human confirmation before proceeding. Other MCPs connect automatically.

---

## Step 6: Install LSP Binaries (if available)

```bash
if which go >/dev/null 2>&1; then
  echo "🔧 Installing gopls..."
  go install golang.org/x/tools/gopls@latest
fi

if which rustup >/dev/null 2>&1; then
  echo "🔧 Installing rust-analyzer..."
  rustup component add rust-analyzer 2>/dev/null || true
fi

which gopls && echo "✅ gopls ready" || echo "⚠️  gopls not found (optional)"
which rust-analyzer && echo "✅ rust-analyzer ready" || echo "⚠️  rust-analyzer not found (optional)"
```

---

## Step 7: Verification Checklist

Run in OpenCode TUI or via API:

```
[ ] opencode service status → "running"
[ ] /mcps → github Connected (after OAuth)
[ ] /mcps → playwright Connected
[ ] /mcps → fetch Connected
[ ] /mcps → filesystem Connected
[ ] /mcps → memory Connected
[ ] /mcps → docker Connected
[ ] kubernetes, postgres, mysql → Disabled (expected)
[ ] skills: manage-mcps, manage-skills loaded
[ ] LSPs connected: typescript, json, css, html, tailwind, eslint, pyright
[ ] LSPs connected: gopls (if installed), rust-analyzer (if installed)
[ ] Filesystem test: "List files in ~/" → works
[ ] GitHub test: "Show my repos" → works (after OAuth)
```

---

## Step 8: Report

Output summary:
- ✅ Steps succeeded (with brief confirmation per step)
- ❌ Steps that failed (with error messages)
- ✅ Services started: `opencode service status` → running
- ⚠️ Manual actions remaining: GitHub OAuth (if not done), rea setup (optional)
- Optional: whether LSP binaries were installed successfully

Done. OpenCode is ready to use on this machine.