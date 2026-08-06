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
# Step 2.5: Install Git (user-space, no admin required)
# =============================================================================
Write-Step "Step 2.5: Install Git"

$gitCmd = Get-Command git -ErrorAction SilentlyContinue
if (-not $gitCmd) {
    Write-Info "Git not found -- Installing in user-space..."

    # Downloading Git Portable
    $gitDir = Join-Path $env:USERPROFILE '.local\git'
    if (-not (Test-Path $gitDir)) { New-Item -ItemType Directory -Path $gitDir -Force | Out-Null }

    $gitUrl = 'https://github.com/git-for-windows/git/releases/download/v2.47.1.windows.2/PortableGit-2.47.1.2-64-bit.7z.exe'
    $gitExe = Join-Path $gitDir 'PortableGit.7z.exe'

    Write-Info "Downloading Git Portable (this may take 1-2 minutes)..."
    try {
        Invoke-WebRequest -Uri $gitUrl -OutFile $gitExe -UseBasicParsing
        Write-Info "Extracting Git..."
        # Use proper argument format for 7z self-extracting archive
        $extractArgs = "-o`"$gitDir`" -y"
        Start-Process -FilePath $gitExe -ArgumentList $extractArgs -Wait -NoNewWindow

        # Add to PATH
        $gitBin = Join-Path $gitDir 'bin'
        $gitCmdDir = Join-Path $gitDir 'cmd'
        $env:Path = $gitBin + ';' + $gitCmdDir + ';' + $env:Path

        # Add to User PATH permanently
        $userPath = [System.Environment]::GetEnvironmentVariable('Path', 'User')
        if ($userPath -notlike "*$gitDir*") {
            [System.Environment]::SetEnvironmentVariable('Path', ($gitBin + ';' + $gitCmdDir + ';' + $userPath), 'User')
        }

        # Clean up installer
        Remove-Item $gitExe -Force -ErrorAction SilentlyContinue

        Write-Ok "Git Portable installed"

        # Refresh PATH immediately so git is available in this session
        $env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')
    }
    catch {
        Write-Err "Git download failed: $_`nPlease check your internet connection and try again."
    }
}
else {
    $gitVer = (git --version) -replace 'git version ', ''
    Write-Ok "git $gitVer"
}

# =============================================================================
# Step 2.7: Install Python 3.11 (user-space, no admin required)
# =============================================================================
Write-Step "Step 2.7: Install Python"

$pythonDir = Join-Path $env:USERPROFILE '.local\python'
$pythonExe = Join-Path $pythonDir 'python.exe'

if (Test-Path $pythonExe) {
    $pythonVer = & $pythonExe --version 2>$null
    Write-Ok "Python already installed: $pythonVer"
} else {
    Write-Info "Python not found -- Installing in user-space..."

    # Download Python embeddable package
    if (-not (Test-Path $pythonDir)) { New-Item -ItemType Directory -Path $pythonDir -Force | Out-Null }

    $pythonUrl = 'https://www.python.org/ftp/python/3.11.9/python-3.11.9-embed-amd64.zip'
    $pythonZip = Join-Path $pythonDir 'python.zip'

    Write-Info "Downloading Python embeddable..."
    try {
        Invoke-WebRequest -Uri $pythonUrl -OutFile $pythonZip -UseBasicParsing
        Write-Info "Extracting Python..."
        Expand-Archive -Path $pythonZip -DestinationPath $pythonDir -Force
        Remove-Item -Path $pythonZip -Force

        # Enable pip by fixing python311._pth
        $pthFile = Join-Path $pythonDir 'python311._pth'
        if (Test-Path $pthFile) {
            $pthContent = Get-Content $pthFile
            $pthContent = $pthContent -replace '#import site', 'import site'
            [System.IO.File]::WriteAllText($pthFile, ($pthContent -join "`r`n"))
        }

        # Install pip
        $getPipUrl = 'https://bootstrap.pypa.io/get-pip.py'
        $getPipFile = Join-Path $pythonDir 'get-pip.py'
        Invoke-WebRequest -Uri $getPipUrl -OutFile $getPipFile -UseBasicParsing

        Start-Process -FilePath $pythonExe -ArgumentList $getPipFile -Wait -NoNewWindow

        # Add to PATH
        $pythonScriptsDir = Join-Path $pythonDir 'Scripts'
        $env:Path = $pythonDir + ';' + $pythonScriptsDir + ';' + $env:Path

        # Add to User PATH permanently
        $userPath = [System.Environment]::GetEnvironmentVariable('Path', 'User')
        if ($userPath -notlike "*$pythonDir*") {
            [System.Environment]::SetEnvironmentVariable('Path', ($pythonDir + ';' + $pythonScriptsDir + ';' + $userPath), 'User')
        }

        Write-Ok "Python embeddable installed"
    }
    catch {
        Write-Err "Python installation failed: $_`nPlease check your internet connection and try again."
    }
}

# =============================================================================
# Step 3: Install Hermes Agent (local install, no admin required)
# =============================================================================
Write-Step "Step 3: Install Hermes Agent"

$hermesDir = Join-Path $HermesHome "hermes-agent"
$hermesExe = Join-Path $hermesDir "venv\Scripts\hermes.exe"

if (Test-Path $hermesExe) {
    $hermesVer = & $hermesExe --version 2>$null
    Write-Ok "Hermes already installed: $hermesVer"
} else {
    Write-Info "Installing Hermes Agent (user-space, no admin required)..."

    # Clone hermes-agent repo
    Write-Info "Cloning hermes-agent repository..."
    try {
        if (Test-Path $hermesDir) {
            Remove-Item $hermesDir -Recurse -Force
        }
        & git clone https://github.com/NousResearch/hermes-agent $hermesDir 2>&1 | Out-Null
        Write-Ok "Repository cloned"
    } catch {
        Write-Err "Failed to clone repository"
        exit 1
    }

    # Create virtual environment
    Write-Info "Creating Python virtual environment..."
    try {
        & python -m venv (Join-Path $hermesDir "venv") 2>&1 | Out-Null
        Write-Ok "Virtual environment created"
    } catch {
        Write-Err "Failed to create virtual environment"
        exit 1
    }

    # Install Python dependencies
    Write-Info "Installing Python dependencies..."
    try {
        $pipPath = Join-Path $hermesDir "venv\Scripts\pip.exe"
        & $pipPath install -e ".[all]" 2>&1 | Out-Null
        Write-Ok "Python dependencies installed"
    } catch {
        Write-Err "Failed to install Python dependencies"
        exit 1
    }

    # Install Node.js dependencies
    Write-Info "Installing Node.js dependencies..."
    try {
        Push-Location $hermesDir
        npm install 2>&1 | Out-Null
        Pop-Location
        Write-Ok "Node.js dependencies installed"
    } catch {
        Write-Err "Failed to install Node.js dependencies"
        exit 1
    }

    Write-Ok "Hermes Agent installed successfully"
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

# Script-scoped variables for OKMD config (used in LiteLLM step for fallback logic)
$script:okmdModels = @()
$script:firstOkmdModel = ""
$script:okmdModelsYaml = ""

if (-not [string]::IsNullOrWhiteSpace($OKMDKey)) {
    # Backup existing config files
    $configPath = Join-Path $HermesHome "config.yaml"
    $envPath = Join-Path $HermesHome ".env"
    
    if (Test-Path $configPath) {
        $backupFile = Join-Path $HermesHome "config.yaml.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
        Copy-Item $configPath $backupFile
        Write-Info "Backed up config.yaml to $backupFile"
    }
    if (Test-Path $envPath) {
        $backupEnv = Join-Path $HermesHome ".env.backup.$(Get-Date -Format 'yyyyMMddHHmmss')"
        Copy-Item $envPath $backupEnv
        Write-Info "Backed up .env to $backupEnv"
    }

    # Query available models from OKMD API
    Write-Info "Querying available models from OKMD..."
    try {
        $response = Invoke-RestMethod -Uri "https://gen.ai.kku.ac.th/okmd/api/v1/models" `
            -Headers @{ "Authorization" = "Bearer $OKMDKey" } `
            -TimeoutSec 10 `
            -SkipCertificateCheck `
            -ErrorAction Stop
        
        $script:okmdModels = $response.data | Where-Object { $_.id } | Select-Object -ExpandProperty id -First 23
        
        if ($script:okmdModels.Count -eq 0) {
            throw "No models returned from API"
        }
        
        Write-Ok "Found $($script:okmdModels.Count) models from OKMD API"
    } catch {
        Write-Warn "Failed to query models - using default model list"
        $script:okmdModels = @(
            "deepseek-v3.2", "gpt-4o", "gpt-4o-mini", "claude-3.5-sonnet", "deepseek-r1",
            "llama-3.3-70b", "grok-2", "qwen-72b-chat", "deepseek-v3.1", "deepseek-chat",
            "deepseek-v3", "gemini-1.5-pro", "gemini-2.0-flash", "gpt-3.5-turbo", "gpt-4-turbo",
            "claude-3-opus", "claude-3-sonnet", "llama-3.1-70b", "mistral-large", "mixtral-8x7b",
            "command-r-plus", "qwen-72b", "yi-34b"
        )
    }

    # Build models section for config.yaml
    foreach ($modelId in $script:okmdModels) {
        if (-not $script:firstOkmdModel) {
            $script:firstOkmdModel = $modelId
        }
        $script:okmdModelsYaml += "      ${modelId}:`n        context_length: 1000000`n"
    }
    
    if (-not $script:firstOkmdModel) {
        $script:firstOkmdModel = "deepseek-v3.2"
    }

    # Create logs directory
    $logsDir = Join-Path $HermesHome "logs"
    New-Item -ItemType Directory -Path $logsDir -Force | Out-Null
    Write-Ok "Created logs directory: $logsDir"

    # Write config.yaml with network binding for remote access
    $configContent = @"
# Hermes Agent Configuration
# Primary: OKMD AI Playground | Fallback: LiteLLM (ถ้าใส่ API key ใน Step 6)
# Generated by install-windows.ps1 on $(Get-Date)

model:
  provider: custom:okmd
  default: $($script:firstOkmdModel)

providers:
  okmd:
    base_url: https://gen.ai.kku.ac.th/okmd/api/v1
    key_env: OKMD_API_KEY
    transport: openai_chat
    models:
$($script:okmdModelsYaml)
# Dashboard - accessible from other machines
dashboard:
  enabled: true
  port: 9119
  host: 0.0.0.0

# Gateway - accessible from other machines
gateway:
  host: 0.0.0.0

# Telegram Gateway
telegram:
  reactions: true

# Logging
logging:
  level: info
  file: $logsDir\hermes.log
"@
    
    Set-Content -Path $configPath -Value $configContent -Encoding UTF8
    Write-Ok "config.yaml created with network binding (0.0.0.0)"
    Write-Ok "Dashboard: http://0.0.0.0:9119 (accessible from other machines)"
    Write-Ok "Default model: $($script:firstOkmdModel)"
    
    # Write .env
    $envContent = @"
# OKMD AI Playground API Key
OKMD_API_KEY=$OKMDKey

# SSL workaround for OKMD (self-signed certificate)
NODE_TLS_REJECT_UNAUTHORIZED=0
"@
    
    Set-Content -Path $envPath -Value $envContent -Encoding UTF8
    Write-Ok ".env created"
    
    Write-Host ""
    Write-Ok "OKMD configuration complete!"
    Write-Info "Default model: $($script:firstOkmdModel)"
    Write-Info "Fallback: LiteLLM (ถ้าใส่ API key ใน Step 6)"
} else {
    Write-Warn "Skipping OKMD setup — you can configure later with: hermes setup"
}
# =============================================================================
# Step 6: Configure LiteLLM Proxy (Course 0)
# =============================================================================
Write-Step "Step 6: Configure LiteLLM Proxy (Optional - Course 0)"

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   LiteLLM Proxy Configuration (Course 0)                ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "  LiteLLM Proxy สำหรับ Course 0 (TPA Training)" -ForegroundColor White
Write-Host "  - Default model: qwen3.7-plus" -ForegroundColor White
Write-Host "  - Hosted on Cloudflare Workers" -ForegroundColor White
Write-Host "  - ไม่ต้องติดตั้ง LiteLLM เอง" -ForegroundColor White
Write-Host ""
Write-Host "  ผู้เรียน Course 0 จะได้รับ API Key จาก instructor" -ForegroundColor White
Write-Host "  ถ้าไม่แน่ใจ → กด Enter เพื่อข้าม" -ForegroundColor White
Write-Host ""

$LiteLLMKey = Read-Host "วาง LiteLLM API Key (หรือกด Enter เพื่อข้าม)"

# Ensure configPath, envPath, logsDir exist even if OKMD was skipped
$configPath = Join-Path $HermesHome "config.yaml"
$envPath = Join-Path $HermesHome ".env"
$logsDir = Join-Path $HermesHome "logs"
New-Item -ItemType Directory -Path $logsDir -Force | Out-Null

if (-not [string]::IsNullOrWhiteSpace($LiteLLMKey)) {
    # Append to .env
    $litellmEnvContent = @"

# LiteLLM Proxy (Course 0)
LITELLM_API_KEY=$LiteLLMKey
"@
    if (Test-Path $envPath) {
        Add-Content -Path $envPath -Value $litellmEnvContent -Encoding UTF8
    } else {
        Set-Content -Path $envPath -Value $litellmEnvContent -Encoding UTF8
    }
    
    # Query available models from LiteLLM API
    Write-Info "Querying available models from LiteLLM Proxy..."
    $litellmModels = @()
    try {
        $ltResponse = Invoke-RestMethod -Uri "https://litellm-proxy-gateway.pbseiyacpro7.workers.dev/v1/models" `
            -Headers @{ "Authorization" = "Bearer $LiteLLMKey" } `
            -TimeoutSec 10 `
            -ErrorAction Stop
        
        $litellmModels = $ltResponse.data | Where-Object { $_.id } | Select-Object -ExpandProperty id
        
        if ($litellmModels.Count -eq 0) {
            throw "No models returned from API"
        }
        
        Write-Ok "Found $($litellmModels.Count) models from LiteLLM Proxy"
    } catch {
        Write-Warn "Failed to query models - using default model list"
        $litellmModels = @(
            "qwen3.7-plus", "qwen3.6-plus", "qwen3.5-plus", "glm-5", "glm-4.7",
            "kimi-k2.5", "MiniMax-M2.5", "qwen3-coder-plus", "qwen3-coder-next",
            "qwen3-max-2026-01-23", "anthropic/qwen3.7-plus", "anthropic/qwen3.6-plus",
            "anthropic/qwen3.5-plus", "anthropic/glm-5", "anthropic/glm-4.7",
            "anthropic/kimi-k2.5", "anthropic/MiniMax-M2.5", "anthropic/qwen3-coder-plus",
            "anthropic/qwen3-coder-next", "anthropic/qwen3-max-2026-01-23"
        )
    }

    # Build LiteLLM models section for config.yaml
    $litellmModelsYaml = ""
    $firstLitellmModel = ""
    foreach ($modelId in $litellmModels) {
        if (-not $firstLitellmModel) {
            $firstLitellmModel = $modelId
        }
        $litellmModelsYaml += "      ${modelId}:`n        context_length: 1000000`n"
    }
    
    if (-not $firstLitellmModel) {
        $firstLitellmModel = "qwen3.7-plus"
    }

    # Determine if we need to add fallback to LiteLLM (if OKMD was configured)
    if (-not [string]::IsNullOrWhiteSpace($OKMDKey) -and $script:okmdModels.Count -gt 0) {
        # OKMD is configured → use OKMD as primary, LiteLLM as fallback
        $configContent = @"
# Hermes Agent Configuration
# Primary: OKMD AI Playground | Fallback: LiteLLM Proxy
# Generated by install-windows.ps1 on $(Get-Date)

model:
  provider: custom:okmd
  default: $($script:firstOkmdModel)
  fallbacks:
    - custom:litellm:$firstLitellmModel

providers:
  okmd:
    base_url: https://gen.ai.kku.ac.th/okmd/api/v1
    key_env: OKMD_API_KEY
    transport: openai_chat
    models:
$($script:okmdModelsYaml)
  litellm:
    base_url: https://litellm-proxy-gateway.pbseiyacpro7.workers.dev/v1
    key_env: LITELLM_API_KEY
    transport: openai_chat
    models:
$litellmModelsYaml
# Dashboard - accessible from other machines
dashboard:
  enabled: true
  port: 9119
  host: 0.0.0.0

# Gateway - accessible from other machines
gateway:
  host: 0.0.0.0

# Telegram Gateway
telegram:
  reactions: true

# Logging
logging:
  level: info
  file: $logsDir\hermes.log
"@
        $fallbackMessage = "OKMD → LiteLLM fallback"
    } else {
        # No OKMD → LiteLLM only (no fallback)
        $configContent = @"
# Hermes Agent Configuration
# Using LiteLLM Proxy as model provider (Course 0)
# Generated by install-windows.ps1 on $(Get-Date)

model:
  provider: custom:litellm
  default: $firstLitellmModel

providers:
  litellm:
    base_url: https://litellm-proxy-gateway.pbseiyacpro7.workers.dev/v1
    key_env: LITELLM_API_KEY
    transport: openai_chat
    models:
$litellmModelsYaml
# Dashboard - accessible from other machines
dashboard:
  enabled: true
  port: 9119
  host: 0.0.0.0

# Gateway - accessible from other machines
gateway:
  host: 0.0.0.0

# Telegram Gateway
telegram:
  reactions: true

# Logging
logging:
  level: info
  file: $logsDir\hermes.log
"@
        $fallbackMessage = "LiteLLM only (no fallback)"
    }
    
    Set-Content -Path $configPath -Value $configContent -Encoding UTF8
    
    Write-Ok "LiteLLM configuration complete!"
    Write-Ok "Dashboard: http://0.0.0.0:9119 (accessible from other machines)"
    Write-Info "Default model: $firstLitellmModel (via LiteLLM Proxy)"
    Write-Info "Models available: $($litellmModels.Count)"
    if (-not [string]::IsNullOrWhiteSpace($OKMDKey) -and $script:okmdModels.Count -gt 0) {
        Write-Ok "Fallback configured: OKMD → LiteLLM"
        Write-Info "ถ้า OKMD quota หมด หรือล่ม → Hermes จะสลับไปใช้ LiteLLM อัตโนมัติ"
    }
} else {
    Write-Info "Skipping LiteLLM setup - Using OKMD as default (no fallback)"
}

# =============================================================================
# Step 5: Telegram Bot Configuration
# =============================================================================
Write-Step "Step 5: Telegram Bot Configuration"

Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   Telegram Bot Setup                                     ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "  📱 สร้าง Telegram Bot:" -ForegroundColor White
Write-Host "  1. เปิด Telegram → ค้นหา @BotFather" -ForegroundColor White
Write-Host "  2. ส่งคำสั่ง /newbot" -ForegroundColor White
Write-Host "  3. ตั้งชื่อ Bot (เช่น My Hermes Bot)" -ForegroundColor White
Write-Host "  4. ตั้ง username (ต้องลงท้ายด้วย bot เช่น my_hermes_bot)" -ForegroundColor White
Write-Host "  5. Copy Bot Token ที่ BotFather ให้ (รูปแบบ: 123456789:ABCdef...)" -ForegroundColor White
Write-Host ""

if ([string]::IsNullOrWhiteSpace($TelegramToken)) {
    $TelegramToken = Read-Host "วาง Telegram Bot Token (หรือกด Enter เพื่อข้าม)"
}

if (-not [string]::IsNullOrWhiteSpace($TelegramToken)) {
    Write-Host ""
    Write-Host "  🔍 หา Telegram Chat ID ของคุณ:" -ForegroundColor White
    Write-Host "  1. เปิด Telegram → ค้นหา @userinfobot" -ForegroundColor White
    Write-Host "  2. ส่งคำสั่ง /start" -ForegroundColor White
    Write-Host "  3. Bot จะตอบกลับด้วย Chat ID ของคุณ (เป็นตัวเลข เช่น 123456789)" -ForegroundColor White
    Write-Host "  4. Copy Chat ID นั้น" -ForegroundColor White
    Write-Host ""
    Write-Host "  ⚠️  Chat ID ใช้สำหรับ:" -ForegroundColor Yellow
    Write-Host "     - อนุญาตให้เฉพาะคุณที่คุยกับ Bot ได้" -ForegroundColor Yellow
    Write-Host "     - ป้องกันคนอื่นใช้ Bot ของคุณ" -ForegroundColor Yellow
    Write-Host ""
    
    $TgUserId = Read-Host "วาง Telegram Chat ID (หรือกด Enter เพื่อข้าม)"
    
    $envPath = Join-Path $HermesHome ".env"
    $tgContent = @"

# Telegram Bot
TELEGRAM_BOT_TOKEN=$TelegramToken
"@
    
    if (-not [string]::IsNullOrWhiteSpace($TgUserId)) {
        $tgContent += @"
TELEGRAM_ALLOWED_USERS=$TgUserId
"@
        Write-Ok "Telegram configuration added (Bot Token + Chat ID)"
    } else {
        Write-Warn "No Chat ID provided - Bot will be accessible to anyone"
    }
    
    Add-Content -Path $envPath -Value $tgContent -Encoding UTF8
} else {
    Write-Warn "Skipping Telegram setup — you can configure later with: hermes gateway setup"
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
    
    # Create batch file for gateway (Telegram) with logging
    $gatewayBat = Join-Path $startupDir "hermes-gateway.bat"
    $gatewayContent = @"
@echo off
set PATH=$NpmGlobal;$env:Path
timeout /t 30 /nobreak >nul
"$hermesBin" gateway start >> "$logsDir\gateway.log" 2>&1
"@
    $gatewayContent | Set-Content $gatewayBat -Encoding ASCII
    
    # Create batch file for dashboard with logging
    $dashboardBat = Join-Path $startupDir "hermes-dashboard.bat"
    $dashboardContent = @"
@echo off
set PATH=$NpmGlobal;$env:Path
timeout /t 60 /nobreak >nul
"$hermesBin" dashboard start >> "$logsDir\dashboard.log" 2>&1
"@
    $dashboardContent | Set-Content $dashboardBat -Encoding ASCII
    
    # Create batch file for desktop with logging
    $desktopBat = Join-Path $startupDir "hermes-desktop.bat"
    $desktopContent = @"
@echo off
set PATH=$NpmGlobal;$env:Path
timeout /t 5 /nobreak >nul
"$hermesBin" desktop >> "$logsDir\desktop.log" 2>&1
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
        Write-Ok "  - HermesGateway (Telegram) - 30s delay"
        Write-Ok "  - HermesDashboard (Dashboard) - 60s delay"
        Write-Ok "  - HermesDesktop (Desktop App) - 5s delay"
        
        # Start services immediately
        Write-Info "Starting services now..."
        try {
            schtasks /Run /TN "HermesGateway" 2>$null
            Write-Ok "Gateway started"
        } catch {
            Write-Warn "Gateway start failed"
        }
        Start-Sleep -Seconds 2
        try {
            schtasks /Run /TN "HermesDashboard" 2>$null
            Write-Ok "Dashboard started"
        } catch {
            Write-Warn "Dashboard start failed"
        }
        Start-Sleep -Seconds 2
        try {
            schtasks /Run /TN "HermesDesktop" 2>$null
            Write-Ok "Desktop started"
        } catch {
            Write-Warn "Desktop start failed"
        }
        
        Write-Info "View logs:"
        Write-Info "  Get-Content $logsDir\gateway.log -Wait"
        Write-Info "  Get-Content $logsDir\dashboard.log -Wait"
        Write-Info "  Get-Content $logsDir\desktop.log -Wait"
    } catch {
        Write-Warn "Task Scheduler creation failed - Using Startup Folder instead"
        
        # Use Startup Folder instead
        $startupFolder = Join-Path $env:APPDATA 'Microsoft\Windows\Start Menu\Programs\Startup'
        
        # Create shortcut for gateway
        $wsShell = New-Object -ComObject WScript.Shell
        $shortcutGateway = $wsShell.CreateShortcut((Join-Path $startupFolder "HermesGateway.lnk"))
        $shortcutGateway.TargetPath = "cmd.exe"
        $shortcutGateway.Arguments = "/c `"$gatewayBat`""
        $shortcutGateway.WindowStyle = 7  # Minimized
        $shortcutGateway.Save()
        
        # Create shortcut for dashboard
        $shortcutDashboard = $wsShell.CreateShortcut((Join-Path $startupFolder "HermesDashboard.lnk"))
        $shortcutDashboard.TargetPath = "cmd.exe"
        $shortcutDashboard.Arguments = "/c `"$dashboardBat`""
        $shortcutDashboard.WindowStyle = 7  # Minimized
        $shortcutDashboard.Save()
        
        # Create shortcut for desktop
        $shortcutDesktop = $wsShell.CreateShortcut((Join-Path $startupFolder "HermesDesktop.lnk"))
        $shortcutDesktop.TargetPath = "cmd.exe"
        $shortcutDesktop.Arguments = "/c `"$desktopBat`""
        $shortcutDesktop.WindowStyle = 1  # Normal window (needs GUI)
        $shortcutDesktop.Save()
        
        Write-Ok "Created Startup Folder shortcuts"
        Write-Ok "  - HermesGateway.lnk (Telegram)"
        Write-Ok "  - HermesDashboard.lnk (Dashboard)"
        Write-Ok "  - HermesDesktop.lnk (Desktop App)"
        
        # Start services immediately via startup folder shortcuts
        Write-Info "Starting services now..."
        try {
            Start-Process (Join-Path $startupFolder "HermesGateway.lnk")
            Write-Ok "Gateway started"
        } catch {
            Write-Warn "Gateway start failed"
        }
        Start-Sleep -Seconds 2
        try {
            Start-Process (Join-Path $startupFolder "HermesDashboard.lnk")
            Write-Ok "Dashboard started"
        } catch {
            Write-Warn "Dashboard start failed"
        }
        Start-Sleep -Seconds 2
        try {
            Start-Process (Join-Path $startupFolder "HermesDesktop.lnk")
            Write-Ok "Desktop started"
        } catch {
            Write-Warn "Desktop start failed"
        }
        
        Write-Info "View logs:"
        Write-Info "  Get-Content $logsDir\gateway.log -Wait"
        Write-Info "  Get-Content $logsDir\dashboard.log -Wait"
        Write-Info "  Get-Content $logsDir\desktop.log -Wait"
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
