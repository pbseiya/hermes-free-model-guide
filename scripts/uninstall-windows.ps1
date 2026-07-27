# =============================================================================
# Hermes Agent Uninstall Script (Windows PowerShell)
# Removes: Hermes Agent, services, startup scripts, PATH entries
# =============================================================================

param(
    [switch]$RemoveAgy,
    [switch]$RemoveNode,
    [switch]$Force
)

$ErrorActionPreference = "Continue"

# Colors for output
function Write-Info    { param($msg) Write-Host "[INFO] " -ForegroundColor Cyan -NoNewline; Write-Host $msg }
function Write-Ok      { param($msg) Write-Host "[OK] " -ForegroundColor Green -NoNewline; Write-Host $msg }
function Write-Warn    { param($msg) Write-Host "[!] " -ForegroundColor Yellow -NoNewline; Write-Host $msg }
function Write-Err     { param($msg) Write-Host "[ERROR] " -ForegroundColor Red -NoNewline; Write-Host $msg }
function Write-Step    { param($msg) Write-Host "`n━━━ $msg ━━━" -ForegroundColor Magenta }

# Banner
Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Red
Write-Host "║              Hermes Agent Uninstaller                    ║" -ForegroundColor Red
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Red
Write-Host ""

if (-not $Force) {
    Write-Host "⚠️  This will remove:" -ForegroundColor Yellow
    Write-Host "  • Hermes Agent and all configuration" -ForegroundColor White
    Write-Host "  • Startup services (Desktop, Dashboard, Telegram)" -ForegroundColor White
    Write-Host "  • ~/.hermes directory (sessions, logs, config)" -ForegroundColor White
    Write-Host ""
    
    $confirm = Read-Host "Are you sure you want to uninstall? (y/N)"
    if ($confirm -ne 'y' -and $confirm -ne 'Y') {
        Write-Info "Uninstallation cancelled"
        exit 0
    }
}

# =============================================================================
# Step 1: Stop Running Services
# =============================================================================
Write-Step "Step 1: Stop Running Services"

# Stop Task Scheduler tasks
try {
    schtasks /End /TN "HermesGateway" 2>$null | Out-Null
    schtasks /End /TN "HermesDashboard" 2>$null | Out-Null
    schtasks /End /TN "HermesDesktop" 2>$null | Out-Null
    Write-Ok "Stopped Task Scheduler tasks"
} catch {
    Write-Warn "Could not stop Task Scheduler tasks"
}

# Stop running processes
$hermesProcs = Get-Process -Name "hermes*","node*","agy*" -ErrorAction SilentlyContinue
if ($hermesProcs) {
    $hermesProcs | Stop-Process -Force -ErrorAction SilentlyContinue
    Write-Ok "Stopped running Hermes processes"
} else {
    Write-Info "No running Hermes processes found"
}

# =============================================================================
# Step 2: Remove Task Scheduler Tasks
# =============================================================================
Write-Step "Step 2: Remove Task Scheduler Tasks"

$tasks = @("HermesGateway", "HermesDashboard", "HermesDesktop")
foreach ($task in $tasks) {
    try {
        schtasks /Delete /TN $task /F 2>$null | Out-Null
        Write-Ok "Removed task: $task"
    } catch {
        Write-Warn "Task not found: $task"
    }
}

# =============================================================================
# Step 3: Remove Startup Shortcuts
# =============================================================================
Write-Step "Step 3: Remove Startup Shortcuts"

$startupFolder = $env:APPDATA + '\Microsoft\Windows\Start Menu\Programs\Startup'
$shortcuts = @("HermesGateway.lnk", "HermesDashboard.lnk", "HermesDesktop.lnk")

foreach ($shortcut in $shortcuts) {
    $shortcutPath = Join-Path $startupFolder $shortcut
    if (Test-Path $shortcutPath) {
        Remove-Item $shortcutPath -Force
        Write-Ok "Removed: $shortcut"
    } else {
        Write-Info "Not found: $shortcut"
    }
}

# =============================================================================
# Step 4: Remove Hermes Installation
# =============================================================================
Write-Step "Step 4: Remove Hermes Installation"

# Remove ~/.hermes directory
$hermesHome = Join-Path $env:USERPROFILE ".hermes"
if (Test-Path $hermesHome) {
    Write-Info "Removing $hermesHome..."
    Remove-Item $hermesHome -Recurse -Force -ErrorAction SilentlyContinue
    if (-not (Test-Path $hermesHome)) {
        Write-Ok "Removed: $hermesHome"
    } else {
        Write-Warn "Could not fully remove $hermesHome (some files may be locked)"
    }
} else {
    Write-Info "~/.hermes not found"
}

# Remove hermes from npm global
$npmGlobal = Join-Path $env:USERPROFILE ".npm-global"
if (Test-Path (Join-Path $npmGlobal "hermes.cmd")) {
    Write-Info "Uninstalling hermes from npm..."
    try {
        npm uninstall -g hermes-agent 2>$null | Out-Null
        Write-Ok "Uninstalled hermes-agent from npm"
    } catch {
        Write-Warn "Could not uninstall from npm"
    }
}

# Remove hermes binary from ~/.local/bin
$localBin = Join-Path $env:USERPROFILE ".local\bin"
if (Test-Path (Join-Path $localBin "hermes.cmd")) {
    Remove-Item (Join-Path $localBin "hermes.cmd") -Force
    Write-Ok "Removed hermes.cmd from ~/.local/bin"
}

# =============================================================================
# Step 5: Remove PATH Entries
# =============================================================================
Write-Step "Step 5: Remove PATH Entries"

$userPath = [System.Environment]::GetEnvironmentVariable('Path', 'User')
$pathsToRemove = @(
    (Join-Path $env:USERPROFILE ".npm-global"),
    (Join-Path $env:USERPROFILE ".local\node"),
    (Join-Path $env:USERPROFILE ".local\bin"),
    (Join-Path $env:LOCALAPPDATA "agy\bin")
)

$pathModified = $false
foreach ($p in $pathsToRemove) {
    if ($userPath -like "*$p*") {
        $userPath = $userPath -replace [regex]::Escape("$p;"), ""
        $userPath = $userPath -replace [regex]::Escape(";$p"), ""
        $userPath = $userPath -replace [regex]::Escape($p), ""
        $pathModified = $true
        Write-Ok "Removed from PATH: $p"
    }
}

if ($pathModified) {
    [System.Environment]::SetEnvironmentVariable('Path', $userPath, 'User')
    Write-Ok "Updated user PATH"
} else {
    Write-Info "No PATH entries to remove"
}

# =============================================================================
# Step 6: Optional - Remove agy
# =============================================================================
if ($RemoveAgy) {
    Write-Step "Step 6: Remove Antigravity CLI (agy)"
    
    $agyDir = Join-Path $env:LOCALAPPDATA "agy"
    if (Test-Path $agyDir) {
        Remove-Item $agyDir -Recurse -Force -ErrorAction SilentlyContinue
        Write-Ok "Removed: $agyDir"
    } else {
        Write-Info "agy not found"
    }
} else {
    Write-Step "Step 6: Skip agy Removal"
    Write-Info "To remove agy, run with -RemoveAgy flag"
}

# =============================================================================
# Step 7: Optional - Remove Node.js
# =============================================================================
if ($RemoveNode) {
    Write-Step "Step 7: Remove Node.js (Portable)"
    
    $nodeDir = Join-Path $env:USERPROFILE ".local\node"
    if (Test-Path $nodeDir) {
        Remove-Item $nodeDir -Recurse -Force -ErrorAction SilentlyContinue
        Write-Ok "Removed: $nodeDir"
    } else {
        Write-Info "Node.js portable not found"
    }
} else {
    Write-Step "Step 7: Skip Node.js Removal"
    Write-Info "To remove Node.js, run with -RemoveNode flag"
}

# =============================================================================
# Done!
# =============================================================================
Write-Host ""
Write-Host "╔════════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║              ✓ Uninstallation Complete!                  ║" -ForegroundColor Green
Write-Host "╚════════════════════════════════════════════════════════════╝" -ForegroundColor Green
Write-Host ""
Write-Host "📝 What was removed:" -ForegroundColor Cyan
Write-Host "  ✓ Hermes Agent and configuration" -ForegroundColor White
Write-Host "  ✓ Startup services (Desktop, Dashboard, Telegram)" -ForegroundColor White
Write-Host "  ✓ ~/.hermes directory" -ForegroundColor White
Write-Host "  ✓ PATH entries" -ForegroundColor White
if ($RemoveAgy) {
    Write-Host "  ✓ Antigravity CLI (agy)" -ForegroundColor White
}
if ($RemoveNode) {
    Write-Host "  ✓ Node.js (portable)" -ForegroundColor White
}
Write-Host ""
Write-Host "🔄 Restart your terminal to apply PATH changes" -ForegroundColor Yellow
Write-Host ""
