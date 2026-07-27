#!/bin/bash
# =============================================================================
# Hermes Agent Uninstall Script (Linux/macOS)
# Removes: Hermes Agent, services, startup scripts, PATH entries
# =============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Functions
info()    { echo -e "${CYAN}[INFO]${NC} $1"; }
ok()      { echo -e "${GREEN}[OK]${NC} $1"; }
warn()    { echo -e "${YELLOW}[!]${NC} $1"; }
err()     { echo -e "${RED}[ERROR]${NC} $1"; }
step()    { echo -e "\n${CYAN}━━━ $1 ━━━${NC}"; }

# Banner
echo ""
echo -e "${RED}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${RED}║              Hermes Agent Uninstaller                    ║${NC}"
echo -e "${RED}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Parse arguments
REMOVE_AGY=false
REMOVE_NODE=false
FORCE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --remove-agy)
            REMOVE_AGY=true
            shift
            ;;
        --remove-node)
            REMOVE_NODE=true
            shift
            ;;
        --force)
            FORCE=true
            shift
            ;;
        *)
            warn "Unknown option: $1"
            shift
            ;;
    esac
done

# Confirmation
if [ "$FORCE" = false ]; then
    echo -e "${YELLOW}⚠️  This will remove:${NC}"
    echo "  • Hermes Agent and all configuration"
    echo "  • Systemd/launchd services (Desktop, Dashboard, Telegram)"
    echo "  • ~/.hermes directory (sessions, logs, config)"
    echo ""
    
    read -p "Are you sure you want to uninstall? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        info "Uninstallation cancelled"
        exit 0
    fi
fi

# =============================================================================
# Step 1: Stop Running Services
# =============================================================================
step "Step 1: Stop Running Services"

# Detect OS
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    PLATFORM="linux"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    PLATFORM="mac"
else
    err "Unsupported platform: $OSTYPE"
    exit 1
fi

# Stop services based on platform
if [ "$PLATFORM" = "linux" ]; then
    if systemctl --user is-active --quiet hermes-gateway.service 2>/dev/null; then
        systemctl --user stop hermes-gateway.service
        ok "Stopped hermes-gateway.service"
    fi
    if systemctl --user is-active --quiet hermes-dashboard.service 2>/dev/null; then
        systemctl --user stop hermes-dashboard.service
        ok "Stopped hermes-dashboard.service"
    fi
    if systemctl --user is-active --quiet hermes-desktop.service 2>/dev/null; then
        systemctl --user stop hermes-desktop.service
        ok "Stopped hermes-desktop.service"
    fi
elif [ "$PLATFORM" = "mac" ]; then
    if launchctl list | grep -q "com.hermes.gateway"; then
        launchctl unload ~/Library/LaunchAgents/com.hermes.gateway.plist 2>/dev/null || true
        ok "Unloaded com.hermes.gateway"
    fi
    if launchctl list | grep -q "com.hermes.dashboard"; then
        launchctl unload ~/Library/LaunchAgents/com.hermes.dashboard.plist 2>/dev/null || true
        ok "Unloaded com.hermes.dashboard"
    fi
    if launchctl list | grep -q "com.hermes.desktop"; then
        launchctl unload ~/Library/LaunchAgents/com.hermes.desktop.plist 2>/dev/null || true
        ok "Unloaded com.hermes.desktop"
    fi
fi

# Kill any remaining Hermes processes
if pgrep -f "hermes" > /dev/null 2>&1; then
    pkill -f "hermes" || true
    ok "Stopped running Hermes processes"
else
    info "No running Hermes processes found"
fi

# =============================================================================
# Step 2: Remove Service Files
# =============================================================================
step "Step 2: Remove Service Files"

if [ "$PLATFORM" = "linux" ]; then
    SYSTEMD_DIR="$HOME/.config/systemd/user"
    
    for service in hermes-gateway hermes-dashboard hermes-desktop; do
        service_file="$SYSTEMD_DIR/$service.service"
        if [ -f "$service_file" ]; then
            systemctl --user disable $service.service 2>/dev/null || true
            rm -f "$service_file"
            ok "Removed: $service.service"
        fi
    done
    
    systemctl --user daemon-reload 2>/dev/null || true
    
elif [ "$PLATFORM" = "mac" ]; then
    LAUNCHD_DIR="$HOME/Library/LaunchAgents"
    
    for plist in com.hermes.gateway.plist com.hermes.dashboard.plist com.hermes.desktop.plist; do
        plist_file="$LAUNCHD_DIR/$plist"
        if [ -f "$plist_file" ]; then
            rm -f "$plist_file"
            ok "Removed: $plist"
        fi
    done
fi

# =============================================================================
# Step 3: Remove Hermes Installation
# =============================================================================
step "Step 3: Remove Hermes Installation"

# Remove ~/.hermes directory
if [ -d "$HOME/.hermes" ]; then
    rm -rf "$HOME/.hermes"
    ok "Removed: ~/.hermes"
else
    info "~/.hermes not found"
fi

# Remove hermes from ~/.local/bin
if [ -f "$HOME/.local/bin/hermes" ]; then
    rm -f "$HOME/.local/bin/hermes"
    ok "Removed: ~/.local/bin/hermes"
fi

# Remove hermes from ~/.local/share
if [ -d "$HOME/.local/share/hermes" ]; then
    rm -rf "$HOME/.local/share/hermes"
    ok "Removed: ~/.local/share/hermes"
fi

# Remove hermes from npm
if command -v npm &> /dev/null; then
    npm uninstall -g hermes-agent 2>/dev/null || true
    ok "Uninstalled hermes-agent from npm"
fi

# =============================================================================
# Step 4: Remove PATH Entries
# =============================================================================
step "Step 4: Remove PATH Entries"

# Detect shell config file
SHELL_CONFIG=""
if [ -n "$ZSH_VERSION" ]; then
    SHELL_CONFIG="$HOME/.zshrc"
elif [ -n "$BASH_VERSION" ]; then
    SHELL_CONFIG="$HOME/.bashrc"
elif [ -f "$HOME/.profile" ]; then
    SHELL_CONFIG="$HOME/.profile"
fi

if [ -n "$SHELL_CONFIG" ] && [ -f "$SHELL_CONFIG" ]; then
    # Remove PATH entries
    sed -i.bak '/\.local\/bin/d' "$SHELL_CONFIG" 2>/dev/null || true
    sed -i.bak '/\.local\/share\/hermes\/bin/d' "$SHELL_CONFIG" 2>/dev/null || true
    sed -i.bak '/\.local\/bin\/agy/d' "$SHELL_CONFIG" 2>/dev/null || true
    
    ok "Removed PATH entries from $SHELL_CONFIG"
else
    info "No shell config file found to update"
fi

# =============================================================================
# Step 5: Optional - Remove agy
# =============================================================================
if [ "$REMOVE_AGY" = true ]; then
    step "Step 5: Remove Antigravity CLI (agy)"
    
    if [ -d "$HOME/.local/bin/agy" ]; then
        rm -rf "$HOME/.local/bin/agy"
        ok "Removed: ~/.local/bin/agy"
    else
        info "agy not found"
    fi
else
    step "Step 5: Skip agy Removal"
    info "To remove agy, run with --remove-agy flag"
fi

# =============================================================================
# Step 6: Optional - Remove Node.js
# =============================================================================
if [ "$REMOVE_NODE" = true ]; then
    step "Step 6: Remove Node.js"
    
    # Remove nvm
    if [ -d "$HOME/.nvm" ]; then
        rm -rf "$HOME/.nvm"
        ok "Removed: ~/.nvm"
    fi
    
    # Remove from shell config
    if [ -n "$SHELL_CONFIG" ] && [ -f "$SHELL_CONFIG" ]; then
        sed -i.bak '/nvm/d' "$SHELL_CONFIG" 2>/dev/null || true
        ok "Removed nvm entries from $SHELL_CONFIG"
    fi
else
    step "Step 6: Skip Node.js Removal"
    info "To remove Node.js, run with --remove-node flag"
fi

# =============================================================================
# Done!
# =============================================================================
echo ""
echo -e "${GREEN}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║              ✓ Uninstallation Complete!                  ║${NC}"
echo -e "${GREEN}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${CYAN}📝 What was removed:${NC}"
echo "  ✓ Hermes Agent and configuration"
echo "  ✓ Systemd/launchd services"
echo "  ✓ ~/.hermes directory"
echo "  ✓ PATH entries"
if [ "$REMOVE_AGY" = true ]; then
    echo "  ✓ Antigravity CLI (agy)"
fi
if [ "$REMOVE_NODE" = true ]; then
    echo "  ✓ Node.js (nvm)"
fi
echo ""
echo -e "${YELLOW}🔄 Restart your terminal to apply PATH changes${NC}"
echo ""
