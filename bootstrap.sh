#!/usr/bin/env bash
# Audit Vault — single-command bootstrap from github.com/CascadeSTEAM/opencode_auditor
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/CascadeSTEAM/opencode_auditor/main/bootstrap.sh | bash
#   curl -fsSL https://raw.githubusercontent.com/CascadeSTEAM/opencode_auditor/main/bootstrap.sh | bash -s -- --dry-run
#   INSTALL_DIR=/custom/path bash <(curl -fsSL ...)
#   (Pin to a specific tag instead of main for stable releases)

set -euo pipefail

REPO="CascadeSTEAM/opencode_auditor"
BRANCH="main"
PARENT_DIR="${PARENT_DIR:-$HOME/opencode-auditor}"
TOOLKIT_DIR="$PARENT_DIR/repo"
GITHUB_RAW="https://raw.githubusercontent.com/$REPO/$BRANCH"

# --- Flags ---
DRY_RUN=false
for arg in "$@"; do
  case "$arg" in
    --dry-run) DRY_RUN=true ;;
    --help) echo "Usage: curl -fsSL $GITHUB_RAW/bootstrap.sh | bash"; exit 0 ;;
  esac
done

# --- Colors ---
GREEN='\033[0;32m'; YELLOW='\033[1;33m'; RED='\033[0;31m'; NC='\033[0m'
info()  { echo -e "${GREEN}✓${NC} $1"; }
warn()  { echo -e "${YELLOW}⚠${NC} $1"; }
fail()  { echo -e "${RED}✗${NC} $1"; }

# --- Prerequisite check ---
echo "=== Audit Vault — Preflight ==="
echo ""

MISSING_DEPS=false
for dep in git jq; do
  if command -v "$dep" &>/dev/null; then
    info "$dep found"
  else
    fail "$dep is required"
    MISSING_DEPS=true
  fi
done

if $MISSING_DEPS; then
  echo ""
  echo "Install missing dependencies:"
  echo "  Ubuntu/Debian: sudo apt install git jq"
  echo "  Fedora:        sudo dnf install git jq"
  echo "  Arch:          sudo pacman -S git jq"
  echo "  macOS:         brew install git jq"
  exit 1
fi

if ! command -v opencode &>/dev/null; then
  echo ""
  warn "OpenCode not found — needed to run audits."
  echo "  Install: curl -fsSL https://opencode.ai/install | bash"
  echo "  Or:      npm i -g opencode-ai@latest"
  echo "  Or:      brew install anomalyco/tap/opencode"
  echo ""

  if [[ "${YES:-}" != "1" ]] && [[ "$DRY_RUN" != true ]]; then
    read -rp "Install OpenCode now? [Y/n] " REPLY
    if [[ -z "$REPLY" || "$REPLY" =~ ^[Yy] ]]; then
      curl -fsSL https://opencode.ai/install | bash
      info "OpenCode installed"
    else
      warn "Skipping OpenCode install. You'll need it later."
    fi
  fi
  echo ""
fi

# --- Ensure parent directory exists ---
mkdir -p "$PARENT_DIR"

# --- Clone or pull toolkit ---
echo "=== Audit Vault — Install ==="
echo ""

if [[ -d "$TOOLKIT_DIR" ]]; then
  if [[ -d "$TOOLKIT_DIR/.git" ]]; then
    info "Toolkit exists at $TOOLKIT_DIR — pulling latest"
    if $DRY_RUN; then
      echo "  Would run: git -C $TOOLKIT_DIR pull origin $BRANCH"
    else
      git -C "$TOOLKIT_DIR" pull origin "$BRANCH"
    fi
  else
    fail "$TOOLKIT_DIR exists but is not a git repo."
    echo "  Remove it or set PARENT_DIR to a different path, then re-run."
    exit 1
  fi
else
  info "Cloning toolkit to $TOOLKIT_DIR"
  if $DRY_RUN; then
    echo "  Would run: git clone --branch $BRANCH https://github.com/$REPO.git $TOOLKIT_DIR"
  else
    git clone --branch "$BRANCH" "https://github.com/$REPO.git" "$TOOLKIT_DIR"
  fi
fi

# --- Global setup (permissions, skills, provider) ---
echo ""
if $DRY_RUN; then
  echo "  Would run: bash $TOOLKIT_DIR/setup/install.sh"
else
  echo "Running global setup..."
  bash "$TOOLKIT_DIR/setup/install.sh"
fi

# --- Create or update a vault ---
echo ""
if $DRY_RUN; then
  echo "  Would run: bash $TOOLKIT_DIR/setup/new-vault.sh"
else
  bash "$TOOLKIT_DIR/setup/new-vault.sh"
fi

# --- Done ---
echo ""
echo "========================================"
echo "  Audit Vault setup complete!"
echo "========================================"
echo ""
echo "  Your vault is ready. To start an audit:"
echo "    cd $PARENT_DIR/<vault-name> && opencode"
echo ""
echo "  The toolkit is at:  $TOOLKIT_DIR"
echo "  Update it anytime:  git -C $TOOLKIT_DIR pull"
echo ""
