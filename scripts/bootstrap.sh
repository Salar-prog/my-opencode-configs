#!/usr/bin/env bash
#
# OpenCode Bootstrap Script — Non-Interactive Setup
#
# What this does (all non-interactive parts):
#   - Checks prerequisites (Node.js, Git, OpenCode, optional Go/Rust/Python)
#   - Clones the dotfiles repo (or updates if already cloned)
#   - Creates symlink ~/.config/opencode -> ~/dotfiles/opencode
#   - Starts OpenCode background service + generates fresh auth token
#   - Installs gopls/rust-analyzer LSP binaries if prerequisites present
#
# What MUST be done manually after this script (interactive requirements):
#   1. GitHub OAuth — inside 'opencode' TUI: Ctrl+P → /mcps → select github → Sign in
#   2. Optional: rea setup — install rea binary, run 'rea mcp', or add config block
#
# Usage: ./scripts/bootstrap.sh
#        Or after downloading:  curl -fsSL https://raw.githubusercontent.com/Salar-prog/my-opencode-configs/main/scripts/bootstrap.sh | sh -

set -uo pipefail

REPO_URL="https://github.com/Salar-prog/my-opencode-configs.git"
DOTFILES_DIR=~/dotfiles
REPO_ROOT="$DOTFILES_DIR"
OPCODE_CONFIG="$HOME/.config/opencode"

# Track results for final summary
RESULT_CLONE=""
RESULT_SYMLINK=""
RESULT_SERVICE=""
RESULT_GOPLS=""
RESULT_RUST=""
RESULT_OPENCODE=""

step_ok() {
  echo ""
  echo "  ✅ $1"
  echo ""
}

step_warn() {
  echo ""
  echo "  ⚠️  $1"
  echo ""
}

step_info() {
  echo ""
  echo "  ℹ️  $1"
  echo ""
}

#######################################################################
# Step 1: Check Prerequisites
#######################################################################
echo "============================================================"
echo "  OpenCode Bootstrap — Automated Setup"
echo "============================================================"
echo ""

echo "📦 Checking prerequisites..."
echo ""

need_fail() {
  echo "❌ MISSING: $1"
  echo ""
  echo "   How to install: $2"
  echo ""
  read -rp "Proceed anyway? [y/N] " confirm < /dev/null || true
  if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Aborted."
    exit 1
  fi
}

if ! which node >/dev/null 2>&1; then
  need_fail "Node.js" "Install via nvm: curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash && source ~/.bashrc && nvm install --lts && nvm use --lts"
fi

if ! which git >/dev/null 2>&1; then
  need_fail "Git" "OS package manager (apt: sudo apt install git / brew: brew install git / dnf: sudo dnf install git)"
fi

if ! which opencode >/dev/null 2>&1; then
  echo "  Installing OpenCode globally..."
  npm install -g @opencode-ai/opencode 2>/dev/null || true
fi

if ! which go >/dev/null 2>&1; then
  step_warn "Go not installed — gopls LSP skipped (optional)"
else
  echo "  Installing gopls (Go LSP)..."
  if go install golang.org/x/tools/gopls@latest 2>/dev/null; then
    echo "  ✅ gopls installed"
    RESULT_GOPLS="ok"
  else
    echo "  ⚠️  Could not install gopls — check go version manually"
    RESULT_GOPLS="failed"
  fi
fi

if ! which rustup >/dev/null 2>&1; then
  step_warn "Rust not installed — rust-analyzer LSP skipped (optional)"
else
  echo "  Installing rust-analyzer (Rust LSP)..."
  if rustup component add rust-analyzer 2>/dev/null; then
    echo "  ✅ rust-analyzer installed"
    RESULT_RUST="ok"
  else
    echo "  ⚠️  Could not add rust-analyzer component — check rustup manually"
    RESULT_RUST="failed"
  fi
fi

echo ""
echo "✅ Prerequisites checked."
echo ""

#######################################################################
# Step 2: Clone Repo
#######################################################################
echo "📁 Cloning dotfiles repo..."
echo ""

if [ ! -d "$DOTFILES_DIR" ]; then
  git clone "$REPO_URL" "$DOTFILES_DIR"
  if [ -f "$REPO_ROOT/opencode/opencode.jsonc" ]; then
    RESULT_CLONE="ok"
  else
    echo "❌ Failed to clone repo (no opencode.jsonc found)."
    exit 1
  fi
else
  cd "$DOTFILES_DIR" && git pull
  if [ -f "$REPO_ROOT/opencode/opencode.jsonc" ]; then
    RESULT_CLONE="ok"
  else
    echo "❌ No updates found or clone issue."
    exit 1
  fi
fi

echo ""
echo "✅ Repo ready at $REPO_ROOT"
echo ""

#######################################################################
# Step 3: Create Symlink
#######################################################################
echo "🔗 Creating symlink: $OPCODE_CONFIG -> $REPO_ROOT/opencode"
echo ""

rm -rf "$OPCODE_CONFIG"
ln -s "$REPO_ROOT/opencode" "$OPCODE_CONFIG"

if [ -L "$OPCODE_CONFIG/opencode.jsonc" ] && [ "$(readlink -f "$OPCODE_CONFIG")" = "$REPO_ROOT/opencode" ]; then
  RESULT_SYMLINK="ok"
  step_ok "Symlink created successfully"
else
  RESULT_SYMLINK="failed"
  echo "❌ Failed to create symlink. Aborting."
  exit 1
fi

echo ""

#######################################################################
# Step 4: Start Service & Generate Auth Token
#######################################################################
echo "🚀 Starting OpenCode background service..."
echo ""

opencode service restart
echo ""

echo "🔍 Checking service status..."
SERVICESTAT=$(opencode service status 2>/dev/null || echo "")
if echo "$SERVICESTAT" | grep -q '"running"'; then
  RESULT_SERVICE="ok"
  step_ok "Service started and running"
else
  RESULT_SERVICE="failed"
  step_warn "Service status unclear — run 'opencode service restart' manually if needed"
fi

echo ""

#######################################################################
# Step 5: Verify Skills Bundled
#######################################################################
echo "📂 Verifying skills are bundled..."
SKILLS_DIR="$OPCODE_CONFIG/skills"
for skill in manage-mcps manage-skills; do
  if [ -d "$SKILLS_DIR/$skill" ]; then
    step_ok "$skill/ skill present"
  else
    step_warn "$skill/ skill missing (symlink issue?) — check: ls $SKILLS_DIR/"
  fi
done

echo ""

#######################################################################
# Final Summary
#######################################################################
echo "============================================"
echo "  SETUP COMPLETE — Summary"
echo "============================================"
echo ""
echo "  ✅ Repo cloned/pulled:     $RESULT_CLONE"
echo "  ✅ Config symlinked:       $RESULT_SYMLINK"
echo "  ✅ Background service:    $RESULT_SERVICE"
echo "  ✅ gopls installed:        $RESULT_GOPLS"
echo "  ✅ rust-analyzer installed:$RESULT_RUST"
echo ""
echo "  Remaining manual steps:"
echo ""
echo "    1. GitHub OAuth (REQUIRED)"
echo "       Run 'opencode'. Inside TUI:"
echo "         Ctrl+P → type '/mcps' → select 'github' → 'Sign in'"
echo ""
echo "    2. Optional: rea setup"
echo "       Install rea binary, then run: rea mcp"
echo "       Or add to ~/.config/opencode/opencode.jsonc:"
echo "           \"rea\": {"
echo "             \"type\": \"local\","
echo "             \"command\": [\"npx\", \"-y\", \"@rea/rea\"],"
echo "             \"enabled\": true"
echo "           }"
echo ""
echo ""
echo "    3. Set environment variable (optional but recommended)"
echo "       In ~/.bashrc or ~/.zshrc add:"
echo '       export GITHUB_TOKEN="ghp_xxx"   # GitHub Personal Access Token with repo scope'
echo "       (Get one at: GitHub Settings → Developer settings → Personal access tokens → Tokens (classic) → Generate new token → repo scope)"
echo ""
echo "--------------------------------------------"
echo "To sync future changes: cd ~/dotfiles && git pull"
echo "Done! OpenCode is ready. 🎉"
echo "--------------------------------------------"