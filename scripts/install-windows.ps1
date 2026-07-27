# =============================================================================
# Hermes Agent Quick Install Script (Windows PowerShell)
# Installs Hermes Agent + configures OKMD AI Playground (Free Model)
# No admin required — everything in user-space
# =============================================================================

param(
    [string]$OKMDKey = "",
    [string]$TelegramToken = "",
    [switch]$SkipPrompts
)

$ErrorActionPreference = "Stop"

# Colors for output
function Write-Info    { param($msg) Write-Host "[INFO] " -ForegroundColor Cyan -NoNewline; Write-Host $msg }
function Write-Ok      { param($msg) Write-Host "[OK] " -ForegroundColor Green -NoNewline; Write-Host $msg }
function Write-Warn    { param($msg) Write-Host "[!] " -ForegroundColor Yellow -NoNewline; Write-Host $msg }
function Write-Err     { param($msg) Write-Host "[ERROR] " -ForegroundColor Red -NoNewline; Write-Host $msg; exit 1 }
function Write-Step    { param($msg) Write-Host "`n━━━ $msg ━━━" -ForegroundColor Magenta }

# Banner
Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   Hermes Agent Quick Install (OKMD Free Model)           ║" -ForegroundColor Cyan
Write-Host "║   Windows — No admin required                            ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

# User-space directories
$HermesHome = Join-Path $env:USERPROFILE ".hermes"
$LocalBin = Join-Path $env:USERPROFILE ".local\bin"
New-Item -ItemType Directory -Path $HermesHome -Force | Out-Null
New-Item -ItemType Directory -Path $LocalBin -Force | Out-Null

# =============================================================================
# Step 1: Check Prerequisites
# =============================================================================
Write-Step "Step 1: Check Prerequisites"

# Check PowerShell version
$PSVer = $PSVersionTable.PSVersion
if ($PSVer.Major -lt 5) {
    Write-Err "Requires PowerShell 5.1+ (current: $PSVer)"
}
Write-Ok "PowerShell $PSVer"

# Check internet
try {
    $testConn = Invoke-WebRequest -Uri "https://hermes-agent.nousresearch.com" -UseBasicParsing -TimeoutSec 10 -ErrorAction Stop
    Write-Ok "Internet connection OK"
} catch {
    Write-Err "Cannot connect to internet. Check your connection."
}

# =============================================================================
# Step 2: Install Node.js (if not exists)
# =============================================================================
Write-Step "Step 2: Install Node.js"

$nodeCmd = Get-Command node -ErrorAction SilentlyContinue
if ($nodeCmd) {
    $nodeVer = node --version
    Write-Ok "Node.js already installed: $nodeVer"
} else {
    Write-Info "Installing Node.js v22 (user-space)..."
    
    # Download Node.js portable
    $nodeDir = Join-Path $env:USERPROFILE ".local\node"
    New-Item -ItemType Directory -Path $nodeDir -Force | Out-Null
    
    $nodeUrl = "https://nodejs.org/dist/v22.12.0/node-v22.12.0-win-x64.zip"
    $nodeZip = Join-Path $nodeDir "node.zip"
    
    try {
        Invoke-WebRequest -Uri $nodeUrl -OutFile $nodeZip -UseBasicParsing
        Write-Info "Extracting Node.js..."
        Expand-Archive -Path $nodeZip -DestinationPath $nodeDir -Force
        Remove-Item $nodeZip -Force
        
        # Find extracted folder
        $extracted = Get-ChildItem -Path $nodeDir -Directory | Where-Object { $_.Name -like "node-v*" } | Select-Object -First 1
        if ($extracted) {
            # Move contents to nodeDir
            Get-ChildItem -Path $extracted.FullName | Move-Item -Destination $nodeDir -Force
            Remove-Item $extracted.FullName -Force -Recurse
        }
        
        # Add to PATH
        $env:Path = "$nodeDir;$env:Path"
        $userPath = [System.Environment]::GetEnvironmentVariable('Path', 'User')
        if ($userPath -notlike "*$nodeDir*") {
            [System.Environment]::SetEnvironmentVariable('Path', "$nodeDir;$userPath", 'User')
        }
        
        Write-Ok "Node.js installed: $(node --version)"
    } catch {
        Write-Warn "Node.js download failed"
        Write-Info "Please install manually: https://nodejs.org/"
        exit 1
    }
}

# =============================================================================
# Step 3: Install Hermes Agent
# =============================================================================
Write-Step "Step 3: Install Hermes Agent"

$hermesCmd = Get-Command hermes -ErrorAction SilentlyContinue
if ($hermesCmd) {
    $hermesVer = hermes --version 2>$null
    Write-Ok "Hermes already installed: $hermesVer"
} else {
    Write-Info "Installing Hermes Agent via npm..."
    
    try {
        npm install -g hermes-agent 2>&1 | Out-Null
        
        # Add npm global to PATH
        $npmGlobal = (npm config get prefix)
        $env:Path = "$npmGlobal;$env:Path"
        $userPath = [System.Environment]::GetEnvironmentVariable('Path', 'User')
        if ($userPath -notlike "*$npmGlobal*") {
            [System.Environment]::SetEnvironmentVariable('Path', "$npmGlobal;$userPath", 'User')
        }
        
        Write-Ok "Hermes installed successfully"
    } catch {
        Write-Err "Failed to install Hermes Agent"
    }
}

# =============================================================================
# Step 4: Configure OKMD AI Playground
# =============================================================================
Write-Step "Step 4: Configure OKMD AI Playground (Free Model)"

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   OKMD AI Playground — Free up to 1M tokens/day         ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "  สมัครฟรีที่: https://playground.okmd.or.th" -ForegroundColor White
Write-Host "  1. Login ด้วย Google Account" -ForegroundColor White
Write-Host "  2. ไปที่ Settings → API Platform" -ForegroundColor White
Write-Host "  3. Generate API Key" -ForegroundColor White
Write-Host "  4. Copy key (ขึ้นต้นด้วย sk_...)" -ForegroundColor White
Write-Host ""

if ([string]::IsNullOrWhiteSpace($OKMDKey)) {
    $OKMDKey = Read-Host "วาง OKMD API Key (หรือกด Enter เพื่อข้าม)"
}

if (-not [string]::IsNullOrWhiteSpace($OKMDKey)) {
    # Write config.yaml
    $configContent = @"
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
"@
    
    $configPath = Join-Path $HermesHome "config.yaml"
    Set-Content -Path $configPath -Value $configContent -Encoding UTF8
    Write-Ok "config.yaml created"
    
    # Write .env
    $envContent = @"
# OKMD AI Playground API Key
OKMD_API_KEY=$OKMDKey

# SSL workaround for OKMD (self-signed certificate)
NODE_TLS_REJECT_UNAUTHORIZED=0
"@
    
    $envPath = Join-Path $HermesHome ".env"
    Set-Content -Path $envPath -Value $envContent -Encoding UTF8
    Write-Ok ".env created"
    
    Write-Host ""
    Write-Ok "OKMD configuration complete!"
    Write-Info "Default model: gpt-5.4-mini (350K tokens/day)"
    Write-Info "DeepSeek V4 Flash: 1M tokens/day (quota เยอะสุด)"
} else {
    Write-Warn "Skipping OKMD setup — you can configure later with: hermes setup"
}

# =============================================================================
# Step 5: Telegram Bot Token (Optional)
# =============================================================================
Write-Step "Step 5: Telegram Bot (Optional)"

Write-Host ""
Write-Host "  สร้าง Telegram Bot:" -ForegroundColor White
Write-Host "  1. เปิด Telegram → ค้นหา @BotFather" -ForegroundColor White
Write-Host "  2. ส่ง /newbot → ตั้งชื่อ → Copy token" -ForegroundColor White
Write-Host ""

if ([string]::IsNullOrWhiteSpace($TelegramToken)) {
    $TelegramToken = Read-Host "วาง Telegram Bot Token (หรือกด Enter เพื่อข้าม)"
}

if (-not [string]::IsNullOrWhiteSpace($TelegramToken)) {
    Write-Host ""
    Write-Info "หา Telegram User ID ของคุณ..."
    Write-Host "  เปิด Telegram → ค้นหา @userinfobot → ส่ง /start" -ForegroundColor White
    Write-Host "  Copy เลข ID ที่ได้" -ForegroundColor White
    Write-Host ""
    
    $TgUserId = Read-Host "วาง Telegram User ID"
    
    $envPath = Join-Path $HermesHome ".env"
    $tgContent = @"

# Telegram Bot
TELEGRAM_BOT_TOKEN=$TelegramToken
TELEGRAM_ALLOWED_USERS=$TgUserId
"@
    
    Add-Content -Path $envPath -Value $tgContent -Encoding UTF8
    Write-Ok "Telegram configuration added"
}

# =============================================================================
# Step 6: Verify Installation
# =============================================================================
Write-Step "Step 6: Verify Installation"

Write-Host ""
$hermesCmd = Get-Command hermes -ErrorAction SilentlyContinue
if ($hermesCmd) {
    $hermesVer = hermes --version 2>$null
    Write-Ok "Hermes: $hermesVer"
} else {
    Write-Warn "hermes command not found — restart PowerShell first"
}

$configPath = Join-Path $HermesHome "config.yaml"
if (Test-Path $configPath) {
    Write-Ok "config.yaml: exists"
} else {
    Write-Warn "config.yaml: not found"
}

$envPath = Join-Path $HermesHome ".env"
if (Test-Path $envPath) {
    Write-Ok ".env: exists"
} else {
    Write-Warn ".env: not found"
}

# =============================================================================
# Done!
# =============================================================================
Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║   ✓ Installation Complete!                               ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "  Commands to try:" -ForegroundColor White
Write-Host "    hermes              # Start chat" -ForegroundColor White
Write-Host "    hermes model        # Change model" -ForegroundColor White
Write-Host "    hermes doctor       # Check health" -ForegroundColor White
Write-Host "    hermes gateway start # Start Telegram bot" -ForegroundColor White
Write-Host ""
Write-Host "  Docs: https://hermes-agent.nousresearch.com/docs/" -ForegroundColor White
Write-Host ""
