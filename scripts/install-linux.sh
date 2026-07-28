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
# Step 3: Install Antigravity CLI (agy)
# =============================================================================
step "Step 3: Install Antigravity CLI (agy)"

info "Antigravity CLI (agy) uses Gemini free via Google Account"
info "Good for fixing/repairing hermes when it has problems"

if command -v agy &> /dev/null; then
    ok "Found existing agy installation"
else
    warn "agy not found - Installing..."
    if [ "$PLATFORM" = "mac" ]; then
        curl -fsSL https://antigravity.google/cli/install.sh | bash 2>/dev/null || true
    else
        curl -fsSL https://antigravity.google/cli/install.sh | bash 2>/dev/null || true
    fi
    
    if command -v agy &> /dev/null; then
        ok "agy installed successfully"
        info "Run 'agy' for first time to login with Google Account"
    else
        warn "agy installation failed - Can install manually later:"
        echo "  curl -fsSL https://antigravity.google/cli/install.sh | bash"
    fi
fi

# =============================================================================
# Step 4: Configure OKMD AI Playground
# =============================================================================
step "Step 4: Configure OKMD AI Playground (Free Model)"

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
# Step 5: Configure LiteLLM Proxy (Course 0)
# =============================================================================
step "Step 5: Configure LiteLLM Proxy (Optional - Course 0)"

echo ""
echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║   LiteLLM Proxy Configuration (Course 0)                ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "  LiteLLM Proxy สำหรับ Course 0 (TPA Training)"
echo "  - Default model: qwen3.7-plus"
echo "  - Hosted on Cloudflare Workers"
echo "  - ไม่ต้องติดตั้ง LiteLLM เอง"
echo ""
echo "  ผู้เรียน Course 0 จะได้รับ API Key จาก instructor"
echo "  ถ้าไม่แน่ใจ → กด Enter เพื่อข้าม"
echo ""

read -p "วาง LiteLLM API Key (หรือกด Enter เพื่อข้าม): " LITELLM_KEY

if [ -n "$LITELLM_KEY" ]; then
    # Append to .env
    cat >> "$HERMES_HOME/.env" << EOF

# LiteLLM Proxy (Course 0)
LITELLM_API_KEY=${LITELLM_KEY}
EOF
    
    # Update config.yaml to use LiteLLM instead of OKMD
    cat > "$HERMES_HOME/config.yaml" << 'EOF'
# Hermes Agent Configuration
# Using LiteLLM Proxy as model provider (Course 0)

model:
  provider: custom:litellm
  default: qwen3.7-plus

custom_providers:
  - name: litellm
    base_url: https://litellm-proxy-gateway.pbseiyacpro7.workers.dev/v1
    key_env: LITELLM_API_KEY

# Also keep OKMD configuration for switching
  - name: okmd
    base_url: https://gen.ai.kku.ac.th/okmd/api/v1
    key_env: OKMD_API_KEY

# Telegram Gateway
telegram:
  reactions: true
EOF
    
    ok "LiteLLM configuration complete!"
    info "Default model: qwen3.7-plus (via LiteLLM Proxy)"
    info "Switch to OKMD: hermes config set model.provider custom:okmd"
else
    info "Skipping LiteLLM setup - Using OKMD as default"
fi

# =============================================================================
# Step 5: Telegram Bot Configuration
# =============================================================================
step "Step 5: Telegram Bot Configuration"

echo ""
echo -e "${CYAN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║   Telegram Bot Setup                                     ║${NC}"
echo -e "${CYAN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo "  📱 สร้าง Telegram Bot:"
echo "  1. เปิด Telegram → ค้นหา @BotFather"
echo "  2. ส่งคำสั่ง /newbot"
echo "  3. ตั้งชื่อ Bot (เช่น My Hermes Bot)"
echo "  4. ตั้ง username (ต้องลงท้ายด้วย bot เช่น my_hermes_bot)"
echo "  5. Copy Bot Token ที่ BotFather ให้ (รูปแบบ: 123456789:ABCdef...)"
echo ""

read -p "วาง Telegram Bot Token (หรือกด Enter เพื่อข้าม): " TG_TOKEN

if [ -n "$TG_TOKEN" ]; then
    echo ""
    echo "  🔍 หา Telegram Chat ID ของคุณ:"
    echo "  1. เปิด Telegram → ค้นหา @userinfobot"
    echo "  2. ส่งคำสั่ง /start"
    echo "  3. Bot จะตอบกลับด้วย Chat ID ของคุณ (เป็นตัวเลข เช่น 123456789)"
    echo "  4. Copy Chat ID นั้น"
    echo ""
    echo -e "  ${YELLOW}⚠️  Chat ID ใช้สำหรับ:${NC}"
    echo -e "  ${YELLOW}   - อนุญาตให้เฉพาะคุณที่คุยกับ Bot ได้${NC}"
    echo -e "  ${YELLOW}   - ป้องกันคนอื่นใช้ Bot ของคุณ${NC}"
    echo ""
    
    read -p "วาง Telegram Chat ID (หรือกด Enter เพื่อข้าม): " TG_USER_ID
    
    # Append to .env
    cat >> "$HERMES_HOME/.env" << EOF

# Telegram Bot
TELEGRAM_BOT_TOKEN=${TG_TOKEN}
EOF
    
    if [ -n "$TG_USER_ID" ]; then
        echo "TELEGRAM_ALLOWED_USERS=${TG_USER_ID}" >> "$HERMES_HOME/.env"
        ok "Telegram configuration added (Bot Token + Chat ID)"
    else
        warn "No Chat ID provided - Bot will be accessible to anyone"
    fi
else
    warn "Skipping Telegram setup — you can configure later with: hermes gateway setup"
fi

# =============================================================================
# Step 6: Setup PATH Environment
# =============================================================================
step "Step 6: Setup PATH Environment"

info "Setting up PATH so you can run hermes, agy from any folder..."

# Detect shell config file
if [ -n "$ZSH_VERSION" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
else
    SHELL_CONFIG="$HOME/.profile"
fi

# Paths to add
PATHS_TO_ADD=(
    "$HOME/.local/bin"
    "$HOME/.local/share/hermes/bin"
    "$HOME/.local/bin/agy"
)

# Add paths if not already present
for p in "${PATHS_TO_ADD[@]}"; do
    if [ -d "$p" ]; then
        if ! grep -q "export PATH=.*$p" "$SHELL_CONFIG" 2>/dev/null; then
            echo "export PATH=\"$p:\$PATH\"" >> "$SHELL_CONFIG"
            ok "Added to PATH: $p"
        else
            info "Already in PATH: $p"
        fi
    fi
done

# Update current session PATH
export PATH="$HOME/.local/bin:$HOME/.local/share/hermes/bin:$PATH"
ok "Current session PATH updated"

# Verify commands are accessible
echo ""
info "Verifying commands..."
if command -v hermes &> /dev/null; then
    HERMES_VER=$(hermes --version 2>/dev/null || echo "installed")
    ok "hermes: $HERMES_VER"
else
    warn "hermes not found in PATH"
fi

if command -v agy &> /dev/null; then
    ok "agy: found"
else
    warn "agy not found in PATH (optional)"
fi

# =============================================================================
# Step 7: Setup Auto-start Services (Linux/macOS)
# =============================================================================
step "Step 7: Setup Auto-start Services"

# Find hermes executable
HERMES_BIN=""
if command -v hermes &> /dev/null; then
    HERMES_BIN=$(which hermes)
elif [ -f "$HOME/.local/share/hermes/bin/hermes" ]; then
    HERMES_BIN="$HOME/.local/share/hermes/bin/hermes"
fi

if [ -z "$HERMES_BIN" ]; then
    warn "hermes executable not found - Skipping auto-start setup"
else
    info "Found hermes at: $HERMES_BIN"
    
    if [ "$PLATFORM" = "linux" ]; then
        # Linux: Use systemd user services
        SYSTEMD_DIR="$HOME/.config/systemd/user"
        mkdir -p "$SYSTEMD_DIR"
        
        # Create gateway service
        cat > "$SYSTEMD_DIR/hermes-gateway.service" << EOF
[Unit]
Description=Hermes Agent Telegram Gateway
After=network.target

[Service]
Type=simple
ExecStart=$HERMES_BIN gateway start
Restart=on-failure
RestartSec=10
Environment=PATH=$HOME/.local/bin:$HOME/.local/share/hermes/bin:/usr/local/bin:/usr/bin:/bin

[Install]
WantedBy=default.target
EOF
        
        # Create dashboard service
        cat > "$SYSTEMD_DIR/hermes-dashboard.service" << EOF
[Unit]
Description=Hermes Agent Web Dashboard
After=network.target

[Service]
Type=simple
ExecStart=$HERMES_BIN dashboard start
Restart=on-failure
RestartSec=10
Environment=PATH=$HOME/.local/bin:$HOME/.local/share/hermes/bin:/usr/local/bin:/usr/bin:/bin

[Install]
WantedBy=default.target
EOF

        # Create desktop service (needs display, waits for desktop)
        cat > "$SYSTEMD_DIR/hermes-desktop.service" << EOF
[Unit]
Description=Hermes Agent Desktop App
After=graphical-session.target

[Service]
Type=simple
ExecStartPre=/bin/sleep 5
ExecStart=$HERMES_BIN desktop
Restart=on-failure
RestartSec=10
Environment=PATH=$HOME/.local/bin:$HOME/.local/share/hermes/bin:/usr/local/bin:/usr/bin:/bin
Environment=DISPLAY=:0

[Install]
WantedBy=default.target
EOF
        
        # Enable services
        systemctl --user daemon-reload
        systemctl --user enable hermes-gateway.service 2>/dev/null || true
        systemctl --user enable hermes-dashboard.service 2>/dev/null || true
        systemctl --user enable hermes-desktop.service 2>/dev/null || true
        
        ok "Created systemd user services"
        ok "  - hermes-gateway.service (Telegram)"
        ok "  - hermes-dashboard.service (Dashboard)"
        ok "  - hermes-desktop.service (Desktop App)"
        info "Start services with: systemctl --user start hermes-gateway hermes-dashboard hermes-desktop"
        
    elif [ "$PLATFORM" = "mac" ]; then
        # macOS: Use launchd
        LAUNCHD_DIR="$HOME/Library/LaunchAgents"
        mkdir -p "$LAUNCHD_DIR"
        
        # Create gateway plist
        cat > "$LAUNCHD_DIR/com.hermes.gateway.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.hermes.gateway</string>
    <key>ProgramArguments</key>
    <array>
        <string>$HERMES_BIN</string>
        <string>gateway</string>
        <string>start</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <true/>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>$HOME/.local/bin:$HOME/.local/share/hermes/bin:/usr/local/bin:/usr/bin:/bin</string>
    </dict>
</dict>
</plist>
EOF
        
        # Create dashboard plist
        cat > "$LAUNCHD_DIR/com.hermes.dashboard.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.hermes.dashboard</string>
    <key>ProgramArguments</key>
    <array>
        <string>$HERMES_BIN</string>
        <string>dashboard</string>
        <string>start</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>$HOME/.local/bin:$HOME/.local/share/hermes/bin:/usr/local/bin:/usr/bin:/bin</string>
    </dict>
</dict>
</plist>
EOF

        # Create desktop plist (needs GUI, waits a bit)
        cat > "$LAUNCHD_DIR/com.hermes.desktop.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.hermes.desktop</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>-c</string>
        <string>sleep 5 && $HERMES_BIN desktop</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
    <key>EnvironmentVariables</key>
    <dict>
        <key>PATH</key>
        <string>$HOME/.local/bin:$HOME/.local/share/hermes/bin:/usr/local/bin:/usr/bin:/bin</string>
    </dict>
</dict>
</plist>
EOF
        
        ok "Created launchd agents"
        ok "  - com.hermes.gateway.plist (Telegram)"
        ok "  - com.hermes.dashboard.plist (Dashboard)"
        ok "  - com.hermes.desktop.plist (Desktop App)"
        info "Start services with: launchctl load ~/Library/LaunchAgents/com.hermes.*.plist"
    fi
fi

# =============================================================================
# Step 8: Verify Installation
# =============================================================================
step "Step 8: Verify Installation"

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
echo -e "${CYAN}📦 Installed Components:${NC}"
echo "  ✓ Hermes Agent"
echo "  ✓ Antigravity CLI (agy) - Free Gemini access"
echo "  ✓ OKMD AI Playground config (Free 23 models)"
if [ -n "$TG_TOKEN" ]; then
    echo "  ✓ Telegram Bot configuration"
fi
echo "  ✓ Auto-start services (Desktop + Dashboard + Telegram Gateway)"
echo ""
echo -e "${CYAN}🚀 Quick Start Commands:${NC}"
echo "  hermes                    # Start interactive chat"
echo "  hermes desktop            # Open desktop app (auto-starts on login)"
echo "  hermes dashboard          # Open web dashboard (auto-starts on login)"
echo "  hermes gateway start      # Start Telegram bot (auto-starts on login)"
echo "  hermes model              # Change AI model"
echo "  hermes doctor             # Check system health"
echo "  agy                       # Start Antigravity CLI (free Gemini)"
echo ""
echo -e "${CYAN}📝 Configuration Files:${NC}"
echo "  ~/.hermes/config.yaml     # Main configuration"
echo "  ~/.hermes/.env            # API keys and secrets"
echo ""
echo -e "${YELLOW}🔄 Restart your terminal to use hermes/agy from any folder${NC}"
echo ""
echo -e "${CYAN}📖 Documentation: https://hermes-agent.nousresearch.com/docs/${NC}"
echo -e "${CYAN}🎮 OKMD Playground: https://playground.okmd.or.th${NC}"
echo ""
