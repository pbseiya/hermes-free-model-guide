#!/usr/bin/env bash
# =============================================================================
# Hermes Agent Quick Install Script (Linux / macOS)
# Installs Hermes Agent + configures OKMD AI Playground (Free Model)
# No sudo required — everything in user-space
# =============================================================================

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;34m'
MAGENTA='\033[0;35m'
NC='\033[0m'

info()    { echo -e "${CYAN}[INFO]${NC} $1"; }
ok()      { echo -e "${GREEN}[OK]${NC} $1"; }
warn()    { echo -e "${YELLOW}[!]${NC} $1"; }
err()     { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }
step()    { echo -e "\n${MAGENTA}━━━ $1 ━━━${NC}"; }

# Banner
echo ""
echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║   Hermes Agent Quick Install (OKMD Free Model)           ║${NC}"
echo -e "${CYAN}║   Linux / macOS — No sudo required                       ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Detect OS
OS="$(uname -s)"
case "$OS" in
    Linux*)   PLATFORM="linux";;
    Darwin*)  PLATFORM="mac";;
    *)        err "Unsupported OS: $OS";;
esac
info "Platform: $PLATFORM"

# Detect architecture
ARCH="$(uname -m)"
case "$ARCH" in
    x86_64|amd64) ARCH="x64";;
    aarch64|arm64) ARCH="arm64";;
    *) err "Unsupported architecture: $ARCH";;
esac
info "Architecture: $ARCH"

# User-space directories
HERMES_HOME="$HOME/.hermes"
LOCAL_BIN="$HOME/.local/bin"
mkdir -p "$HERMES_HOME" "$LOCAL_BIN"

# =============================================================================
# Step 1: Check Prerequisites
# =============================================================================
step "Step 1: Check Prerequisites"

# Check internet
if curl -sf --max-time 5 "https://hermes-agent.nousresearch.com" > /dev/null 2>&1; then
    ok "Internet connection OK"
else
    err "Cannot connect to internet. Check your connection."
fi

# =============================================================================
# Step 2: Install Hermes Agent
# =============================================================================
step "Step 2: Install Hermes Agent"

# Check if hermes is already installed
if command -v hermes &> /dev/null; then
    HERMES_VER=$(hermes --version 2>/dev/null || echo "unknown")
    ok "Hermes already installed: $HERMES_VER"
else
    info "Installing Hermes Agent via official installer..."
    
    # Use official Hermes installer
    curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash
    
    # Add to PATH for current session
    export PATH="$LOCAL_BIN:$HOME/.local/share/hermes/bin:$PATH"
    
    if command -v hermes &> /dev/null; then
        ok "Hermes installed successfully"
    else
        warn "Hermes installed but not in PATH yet"
        info "Please restart your terminal or run: source ~/.bashrc (or ~/.zshrc)"
    fi
fi

# =============================================================================
# Step 3: Configure OKMD AI Playground
# =============================================================================
step "Step 3: Configure OKMD AI Playground (Free Model)"

echo ""
echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║   OKMD AI Playground — Free up to 1M tokens/day         ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "  สมัครฟรีที่: https://playground.okmd.or.th"
echo "  1. Login ด้วย Google Account"
echo "  2. ไปที่ Settings → API Platform"
echo "  3. Generate API Key"
echo "  4. Copy key (ขึ้นต้นด้วย sk_...)"
echo ""

read -p "วาง OKMD API Key (หรือกด Enter เพื่อข้าม): " OKMD_KEY

if [ -n "$OKMD_KEY" ]; then
    # Write config.yaml
    cat > "$HERMES_HOME/config.yaml" << 'EOF'
# Hermes Agent Configuration
# Using OKMD AI Playground as free model provider

model:
  provider: custom:okmd
  default: gpt-5.4-mini

providers:
  okmd:
    base_url: https://gen.ai.kku.ac.th/okmd/api/v1
    key_env: OKMD_API_KEY
    transport: openai_chat

# Telegram Gateway
telegram:
  reactions: true
EOF
    ok "config.yaml created"

    # Write .env
    cat > "$HERMES_HOME/.env" << EOF
# OKMD AI Playground API Key
OKMD_API_KEY=${OKMD_KEY}

# SSL workaround for OKMD (self-signed certificate)
NODE_TLS_REJECT_UNAUTHORIZED=0
EOF
    chmod 600 "$HERMES_HOME/.env"
    ok ".env created (permissions: 600)"

    echo ""
    ok "OKMD configuration complete!"
    info "Default model: gpt-5.4-mini (350K tokens/day)"
    info "DeepSeek V4 Flash: 1M tokens/day (quota เยอะสุด)"
else
    warn "Skipping OKMD setup — you can configure later with: hermes setup"
fi

# =============================================================================
# Step 4: Telegram Bot Token (Optional)
# =============================================================================
step "Step 4: Telegram Bot (Optional)"

echo ""
echo "  สร้าง Telegram Bot:"
echo "  1. เปิด Telegram → ค้นหา @BotFather"
echo "  2. ส่ง /newbot → ตั้งชื่อ → Copy token"
echo ""

read -p "วาง Telegram Bot Token (หรือกด Enter เพื่อข้าม): " TG_TOKEN

if [ -n "$TG_TOKEN" ]; then
    # Get Telegram User ID
    echo ""
    info "หา Telegram User ID ของคุณ..."
    echo "  เปิด Telegram → ค้นหา @userinfobot → ส่ง /start"
    echo "  Copy เลข ID ที่ได้"
    echo ""
    read -p "วาง Telegram User ID: " TG_USER_ID

    # Append to .env
    cat >> "$HERMES_HOME/.env" << EOF

# Telegram Bot
TELEGRAM_BOT_TOKEN=${TG_TOKEN}
TELEGRAM_ALLOWED_USERS=${TG_USER_ID:-*}
EOF
    ok "Telegram configuration added"
fi

# =============================================================================
# Step 5: Verify Installation
# =============================================================================
step "Step 5: Verify Installation"

echo ""
if command -v hermes &> /dev/null; then
    ok "Hermes: $(hermes --version 2>/dev/null || echo 'installed')"
else
    warn "hermes command not found — restart terminal first"
fi

if [ -f "$HERMES_HOME/config.yaml" ]; then
    ok "config.yaml: exists"
else
    warn "config.yaml: not found"
fi

if [ -f "$HERMES_HOME/.env" ]; then
    ok ".env: exists"
else
    warn ".env: not found"
fi

# =============================================================================
# Done!
# =============================================================================
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   ✅ Installation Complete!                              ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "  Commands to try:"
echo "    hermes              # Start chat"
echo "    hermes model        # Change model"
echo "    hermes doctor       # Check health"
echo "    hermes gateway start # Start Telegram bot"
echo ""
echo "  Docs: https://hermes-agent.nousresearch.com/docs/"
echo ""
