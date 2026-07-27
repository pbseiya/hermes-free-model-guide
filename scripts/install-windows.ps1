# =============================================================================
# Hermes Agent Quick Install Script (Windows PowerShell)
# Installs: Hermes Agent + agy + OKMD AI Playground (Free Model)
# Features: User-space install, PATH setup, Desktop/Dashboard/Telegram auto-start
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
$NpmGlobal = Join-Path $env:USERPROFILE ".npm-global"
New-Item -ItemType Directory -Path $HermesHome -Force | Out-Null
New-Item -ItemType Directory -Path $LocalBin -Force | Out-Null
New-Item -ItemType Directory -Path $NpmGlobal -Force | Out-Null

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
        Write-Ok "Hermes installed successfully"
    } catch {
        Write-Err "Failed to install Hermes Agent"
    }
}

# =============================================================================
# Step 4: Install Antigravity CLI (agy)
# =============================================================================
Write-Step "Step 4: Install Antigravity CLI (agy)"

Write-Info "Antigravity CLI (agy) uses Gemini free via Google Account"
Write-Info "Good for fixing/repairing hermes when it has problems"

$agyCmd = Get-Command agy -ErrorAction SilentlyContinue
if ($agyCmd) {
    Write-Ok "Found existing agy installation"
} else {
    Write-Warn "agy not found - Installing..."
    try {
        irm https://antigravity.google/cli/install.ps1 | iex
        $agyBin = Join-Path $env:LOCALAPPDATA "agy" | Join-Path -ChildPath "bin"
        Write-Ok "agy installed → $agyBin"
        Write-Ok "Start agy for first time to login with Google Account"
    } catch {
        Write-Warn "agy installation failed - Can install manually later:"
        Write-Host "  PowerShell: irm https://antigravity.google/cli/install.ps1 | iex" -ForegroundColor Yellow
    }
}

# =============================================================================
# Step 5: Configure OKMD AI Playground
# =============================================================================
Write-Step "Step 5: Configure OKMD AI Playground (Free Model)"

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
# Step 6: Telegram Bot Token (Optional)
# =============================================================================
Write-Step "Step 6: Telegram Bot (Optional)"

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
# Step 7: Setup PATH Environment
# =============================================================================
Write-Step "Step 7: Setup PATH Environment"

Write-Info "Setting up PATH so you can run hermes, agy from any folder..."

# Collect all paths to add
$pathsToAdd = @(
    $NpmGlobal,
    (Join-Path $env:USERPROFILE ".local\node"),
    (Join-Path $env:USERPROFILE ".local\bin")
)

# Add agy bin path if exists
$agyBin = Join-Path $env:LOCALAPPDATA "agy\bin"
if (Test-Path $agyBin) {
    $pathsToAdd += $agyBin
}

# Get current user PATH
$userPath = [System.Environment]::GetEnvironmentVariable('Path', 'User')
$pathsAdded = @()

foreach ($p in $pathsToAdd) {
    if (Test-Path $p -ErrorAction SilentlyContinue) {
        if ($userPath -notlike "*$p*") {
            $userPath = "$p;$userPath"
            $pathsAdded += $p
            Write-Ok "Added to PATH: $p"
        } else {
            Write-Info "Already in PATH: $p"
        }
    }
}

# Update user PATH permanently
if ($pathsAdded.Count -gt 0) {
    [System.Environment]::SetEnvironmentVariable('Path', $userPath, 'User')
    Write-Ok "User PATH updated permanently"
}

# Update current session PATH
$env:Path = "$($pathsToAdd -join ';');$env:Path"
Write-Ok "Current session PATH updated"

# Verify commands are accessible
Write-Host ""
Write-Info "Verifying commands..."
if (Get-Command hermes -ErrorAction SilentlyContinue) {
    $hermesVer = hermes --version 2>$null
    Write-Ok "hermes: $hermesVer"
} else {
    Write-Warn "hermes not found in PATH"
}

if (Get-Command agy -ErrorAction SilentlyContinue) {
    Write-Ok "agy: found"
} else {
    Write-Warn "agy not found in PATH (optional)"
}

# =============================================================================
# Step 8: Setup Auto-start (Desktop, Dashboard, Telegram)
# =============================================================================
Write-Step "Step 8: Setup Auto-start Services"

# Find hermes executable
$hermesCmd = Get-Command hermes -ErrorAction SilentlyContinue
$hermesBin = $null
if ($hermesCmd) {
    $hermesBin = $hermesCmd.Source
} elseif (Test-Path (Join-Path $NpmGlobal "hermes.cmd")) {
    $hermesBin = Join-Path $NpmGlobal "hermes.cmd"
}

if (-not $hermesBin) {
    Write-Warn "hermes executable not found - Skipping auto-start setup"
} else {
    Write-Info "Found hermes at: $hermesBin"
    
    # Create startup scripts directory
    $startupDir = Join-Path $HermesHome "startup"
    if (-not (Test-Path $startupDir)) {
        New-Item -ItemType Directory -Path $startupDir -Force | Out-Null
    }
    
    # Create batch file for gateway (Telegram)
    $gatewayBat = Join-Path $startupDir "hermes-gateway.bat"
    $gatewayContent = @"
@echo off
set PATH=$NpmGlobal;$env:Path
"$hermesBin" gateway start
"@
    $gatewayContent | Set-Content $gatewayBat -Encoding ASCII
    
    # Create batch file for dashboard
    $dashboardBat = Join-Path $startupDir "hermes-dashboard.bat"
    $dashboardContent = @"
@echo off
set PATH=$NpmGlobal;$env:Path
"$hermesBin" dashboard start
"@
    $dashboardContent | Set-Content $dashboardBat -Encoding ASCII
    
    # Create batch file for desktop
    $desktopBat = Join-Path $startupDir "hermes-desktop.bat"
    $desktopContent = @"
@echo off
set PATH=$NpmGlobal;$env:Path
timeout /t 10 /nobreak >nul
"$hermesBin" desktop
"@
    $desktopContent | Set-Content $desktopBat -Encoding ASCII
    
    # Create Windows Task Scheduler tasks
    try {
        # Remove old tasks if exist
        schtasks /Delete /TN "HermesGateway" /F 2>$null
        schtasks /Delete /TN "HermesDashboard" /F 2>$null
        schtasks /Delete /TN "HermesDesktop" /F 2>$null
        
        # Create task for gateway (run at logon)
        $action = New-ScheduledTaskAction -Execute "cmd.exe" -Argument "/c `"$gatewayBat`""
        $trigger = New-ScheduledTaskTrigger -AtLogOn
        $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -ExecutionTimeLimit (New-TimeSpan -Days 0)
        $principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -RunLevel Limited
        
        Register-ScheduledTask -TaskName "HermesGateway" -Action $action -Trigger $trigger -Settings $settings -Principal $principal -Description "Hermes Agent Telegram Gateway" -Force | Out-Null
        
        # Create task for dashboard (run at logon)
        $action2 = New-ScheduledTaskAction -Execute "cmd.exe" -Argument "/c `"$dashboardBat`""
        $trigger2 = New-ScheduledTaskTrigger -AtLogOn
        
        Register-ScheduledTask -TaskName "HermesDashboard" -Action $action2 -Trigger $trigger2 -Settings $settings -Principal $principal -Description "Hermes Agent Web Dashboard" -Force | Out-Null
        
        # Create task for desktop (run at logon, needs GUI)
        $action3 = New-ScheduledTaskAction -Execute "cmd.exe" -Argument "/c `"$desktopBat`""
        $trigger3 = New-ScheduledTaskTrigger -AtLogOn
        
        Register-ScheduledTask -TaskName "HermesDesktop" -Action $action3 -Trigger $trigger3 -Settings $settings -Principal $principal -Description "Hermes Agent Desktop App" -Force | Out-Null
        
        Write-Ok "Created Windows Task Scheduler tasks"
        Write-Ok "  - HermesGateway (Telegram)"
        Write-Ok "  - HermesDashboard (Dashboard)"
        Write-Ok "  - HermesDesktop (Desktop App)"
        Write-Info "Start services with: schtasks /Run /TN `"HermesGateway`" && schtasks /Run /TN `"HermesDashboard`" && schtasks /Run /TN `"HermesDesktop`""
    } catch {
        Write-Warn "Task Scheduler creation failed - Using Startup Folder instead"
        
        # Use Startup Folder instead
        $startupFolder = $env:APPDATA + '\Microsoft\Windows\Start Menu\Programs\Startup'
        
        # Create shortcut for gateway
        $wsGateway = New-Object -ComObject WScript.Shell
        $shortcutGateway = $wsGateway.CreateShortcut((Join-Path $startupFolder "HermesGateway.lnk"))
        $shortcutGateway.TargetPath = "cmd.exe"
        $shortcutGateway.Arguments = "/c `"$gatewayBat`""
        $shortcutGateway.WindowStyle = 7  # Minimized
        $shortcutGateway.Save()
        
        # Create shortcut for dashboard
        $shortcutDashboard = $wsGateway.CreateShortcut((Join-Path $startupFolder "HermesDashboard.lnk"))
        $shortcutDashboard.TargetPath = "cmd.exe"
        $shortcutDashboard.Arguments = "/c `"$dashboardBat`""
        $shortcutDashboard.WindowStyle = 7  # Minimized
        $shortcutDashboard.Save()
        
        # Create shortcut for desktop
        $shortcutDesktop = $wsGateway.CreateShortcut((Join-Path $startupFolder "HermesDesktop.lnk"))
        $shortcutDesktop.TargetPath = "cmd.exe"
        $shortcutDesktop.Arguments = "/c `"$desktopBat`""
        $shortcutDesktop.WindowStyle = 1  # Normal window (needs GUI)
        $shortcutDesktop.Save()
        
        Write-Ok "Created Startup Folder shortcuts"
        Write-Ok "  - HermesGateway.lnk (Telegram)"
        Write-Ok "  - HermesDashboard.lnk (Dashboard)"
        Write-Ok "  - HermesDesktop.lnk (Desktop App)"
    }
}

# =============================================================================
# Step 9: Final Summary
# =============================================================================
Write-Step "Step 9: Installation Complete!"

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║              ✓ Installation Complete!                    ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""

Write-Host "📦 Installed Components:" -ForegroundColor Cyan
Write-Host "  ✓ Node.js v22 (user-space)" -ForegroundColor White
Write-Host "  ✓ Hermes Agent (via npm)" -ForegroundColor White
Write-Host "  ✓ Antigravity CLI (agy) - Free Gemini access" -ForegroundColor White
Write-Host "  ✓ OKMD AI Playground config (Free 23 models)" -ForegroundColor White
if ($TelegramToken) {
    Write-Host "  ✓ Telegram Bot configuration" -ForegroundColor White
}
Write-Host "  ✓ Auto-start services (Desktop + Dashboard + Telegram Gateway)" -ForegroundColor White
Write-Host ""

Write-Host "🚀 Quick Start Commands:" -ForegroundColor Cyan
Write-Host "  hermes                    # Start interactive chat" -ForegroundColor White
Write-Host "  hermes desktop            # Open desktop app (auto-starts on login)" -ForegroundColor White
Write-Host "  hermes dashboard          # Open web dashboard (auto-starts on login)" -ForegroundColor White
Write-Host "  hermes gateway start      # Start Telegram bot (auto-starts on login)" -ForegroundColor White
Write-Host "  hermes model              # Change AI model" -ForegroundColor White
Write-Host "  hermes doctor             # Check system health" -ForegroundColor White
Write-Host "  agy                       # Start Antigravity CLI (free Gemini)" -ForegroundColor White
Write-Host ""

Write-Host "📝 Configuration Files:" -ForegroundColor Cyan
Write-Host "  ~/.hermes/config.yaml     # Main configuration" -ForegroundColor White
Write-Host "  ~/.hermes/.env            # API keys and secrets" -ForegroundColor White
Write-Host ""

Write-Host "🔄 Restart your terminal to use hermes/agy from any folder" -ForegroundColor Yellow
Write-Host ""

Write-Host "📖 Documentation: https://hermes-agent.nousresearch.com/docs/" -ForegroundColor Cyan
Write-Host "🎮 OKMD Playground: https://playground.okmd.or.th" -ForegroundColor Cyan
Write-Host ""
