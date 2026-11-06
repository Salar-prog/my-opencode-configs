#!/usr/bin/env bash
#
# OpenCode Bootstrap Script — Non-Interactive Setup
#
# Automates everything that can be automated:
#   - Clone dotfiles repo
#   - Link OpenCode config via symlink
#   - Generate service auth token
#   - Install LSP binaries (gopls, rust-analyzer) if prerequisites present
#
# What MUST be done manually:
#   - GitHub OAuth (interactive sign-in via /mcps)
#   - Optional: rea setup (manually install binary, run `rea mcp`)
#   - Set environment variables (GITHUB_TOKEN etc.)
#
# Usage: ./scripts/bootstrap.sh

set -euo pipefail

REPO_URL="https://github.com/Salar-prog/my-opencode-configs.git"
DOTFILES_DIR=~/dotfiles
REPO_ROOT="$DOTFILES_DIR"
OPCODE_CONFIG="$HOME/.config/opencode"

echo "============================================================"
echo "  OpenCode Bootstrap — Automated Setup"
echo "============================================================"
echo ""

#######################################################################
# Step 1: Check Prerequisites
#######################################################################
echo "📦 Checking prerequisites..."

need_fail() {
  echo "❌ MISSING: $1"
  echo ""
  echo "Manual actions needed:"
  echo "  1. Install: $2"
  echo ""
  echo "Run this command to fix:"
  echo "  $3"
  echo ""
  read -rp "Proceed anyway? [y/N] " confirm < /dev/null || true
  if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
    echo "Aborted."
    exit 1
  fi
}

if ! which node >/dev/null 2>&1; then
  need_fail "Node.js" "nvm install --lts && nvm use --lts" "curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash && source ~/.bashrc && nvm install --lts && nvm use --lts"
fi

if ! which git >/dev/null 2>&1; then
  need_fail "Git" "OS package manager (apt/brew/dnf)" "sudo apt install git  # or: brew install git / sudo dnf install git"
fi

if ! which opencode >/dev/null 2>&1; then
  echo "⚠️  OpenCode not found on PATH. Installing globally..."
  npm install -g @opencode-ai/opencode 2>/dev/null || echo "⚠️  Could not auto-install OpenCode. Please install manually: npm install -g @opencode-ai/opencode"
fi

# Optional prerequisites
if ! which go >/dev/null 2>&1; then
  echo "⚠️  Go not installed. Skipping gopls (optional)."
else
  echo "🔧 Installing gopls (Go LSP)..."
  go install golang.org/x/tools/gopls@latest
fi

if ! which rustup >/dev/null 2>&1; then
  echo "⚠️  Rust not found. Skipping rust-analyzer (optional)."
else
  echo "🔧 Installing rust-analyzer (Rust LSP)..."
  rustup component add rust-analyzer 2>/dev/null || echo "⚠️  Could not add rust-analyzer component. Try: rustup component add rust-analyzer"
fi

echo ""
echo "✅ Prerequisites checked."
echo ""

#######################################################################
# Step 2: Clone Repo (or update)
#######################################################################
echo "📁 Cloning dotfiles repo..."

if [ ! -d "$DOTFILES_DIR" ]; then
  git clone "$REPO_URL" "$DOTFILES_DIR"
else
  cd "$DOTFILES_DIR"
  git pull
fi

if [ ! -f "$REPO_ROOT/opencode/opencode.jsonc" ]; then
  echo "❌ Error: opencode.jsonc not found in repo. Aborting."
  exit 1
fi

echo "✅ Repo ready at $REPO_ROOT"
echo ""

#######################################################################
# Step 3: Create Symlink
#######################################################################
echo "🔗 Creating symlink: $OPCODE_CONFIG -> $REPO_ROOT/opencode"

rm -rf "$OPCODE_CONFIG"
ln -s "$REPO_ROOT/opencode" "$OPCODE_CONFIG"

if [ -L "$OPCODE_CONFIG/opencode.jsonc" ] && [ "$(readlink -f "$OPCODE_CONFIG")" = "$REPO_ROOT/opencode" ]; then
  echo "✅ Symlink created"
else
  echo "❌ Failed to create symlink. Aborting."
  exit 1
fi

echo ""

#######################################################################
# Step 4: Start Service & Generate Auth Token
#######################################################################
echo "🚀 Starting OpenCode background service..."
opencode service restart
echo ""

echo "🔍 Checking service status..."
opencode service status
echo ""

if ! opencode service status 2>/dev/null | grep -q '"running"'; then
  echo "⚠️  Service may not be running yet. Try again in a moment, or run:"
  echo "   opencode service restart"
fi

echo ""

#######################################################################
# Step 5: Verify Skills Present
#######################################################################
echo "📂 Verifying skills are bundled..."
SKILLS_DIR="$OPCODE_CONFIG/skills"

for skill in manage-mcps manage-skills; do
  if [ -d "$SKILLS_DIR/$skill" ]; then
    echo "   ✅ $skill/"
  else
    echo "   ⚠️  $skill/ is missing (symlink issue?) — check with: ls $SKILLS_DIR/"
  fi
done

echo ""
echo "============================================"
echo "  Automation Complete!"
echo "============================================"
echo ""
echo "Two manual steps remain:"
echo ""
echo "  1. GitHub OAuth (REQUIRED for GitHub MCP)"
echo "     Run 'opencode' and inside the TUI:"
echo "       Ctrl+P → type '/mcps' → select 'github' → 'Sign in'"
echo ""
echo "  2. Optional rea setup (for reverse engineering)"
echo "     Install rea, then run 'rea mcp'"
echo ""
echo "Also set these env vars in your shell profile (~/.bashrc, ~/.zshrc):"
echo '     export GITHUB_TOKEN="ghp_xxx"  # GitHub Personal Access Token with repo scope'
echo "     # OR: gh auth token (if GitHub CLI installed)"
echo ""
echo "--------------------------------------------"
echo "Next steps:"
echo "  cd ~/dotfiles && git pull   # sync future changes"
echo "Done! OpenCode is ready to use. 🎉"
echo "--------------------------------------------"
