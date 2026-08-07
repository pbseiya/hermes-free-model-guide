# =============================================================================
# Hermes Agent Quick Install Script (OKMD Free Model - User-Space)
# Supports: Windows (PowerShell 5.1+)
# Usage: .\install-windows.ps1
# =============================================================================

param(
    [switch]$SkipInstall,
    [switch]$Force
)

# Override execution policy for this process (required for irm | iex)
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass -Force

$ErrorActionPreference = 'Stop'

# --- Helpers ---
function Write-Info    { param($msg) Write-Host '[INFO] ' -ForegroundColor Cyan -NoNewline; Write-Host $msg }
function Write-Ok      { param($msg) Write-Host '[OK] ' -ForegroundColor Green -NoNewline; Write-Host $msg }
function Write-Warn    { param($msg) Write-Host '[!] ' -ForegroundColor Yellow -NoNewline; Write-Host $msg }
function Write-Err     { param($msg) Write-Host '[ERROR] ' -ForegroundColor Red -NoNewline; Write-Host $msg; exit 1 }
function Write-Step    { param($msg) Write-Host ('`n=== {0} ===' -f $msg) -ForegroundColor Magenta }

# --- Python validation (Windows App Execution Alias detection) ---
function Test-PythonValid {
    $cmd = Get-Command python -ErrorAction SilentlyContinue
    if (-not $cmd) {
        $cmd = Get-Command python3 -ErrorAction SilentlyContinue
    }
    if (-not $cmd) { return $false }
    if ($cmd.Source -like '*WindowsApps*') { return $false }
    try {
        $prevEAP = $ErrorActionPreference
        $ErrorActionPreference = 'Continue'
        $ver = & $cmd.Source --version 2>&1
        $ErrorActionPreference = $prevEAP
        if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne $null) { return $false }
        if ("$ver" -like '*was not found*') { return $false }
        return $true
    }
    catch { return $false }
}

# --- Banner ---
Write-Host ''
Write-Host '============================================================' -ForegroundColor Cyan
Write-Host '   Hermes Agent Quick Install (OKMD Free Model)            ' -ForegroundColor Cyan
Write-Host '   Windows - No admin required                              ' -ForegroundColor Cyan
Write-Host '============================================================' -ForegroundColor Cyan
Write-Host ''
Write-Host '️  IMPORTANT: Disable ALL antivirus real-time protection!' -ForegroundColor Yellow
Write-Host '   - Trend Micro Apex One' -ForegroundColor Yellow
Write-Host '   - Windows Defender (Set-MpPreference -DisableRealtimeMonitoring $true)' -ForegroundColor Yellow
Write-Host ''

# --- Detect Environment ---
$isWSL = $false
if (Test-Path '/proc/version') {
    try {
        $procVer = Get-Content '/proc/version' -ErrorAction SilentlyContinue
        if ($procVer -match 'microsoft|WSL') {
            $isWSL = $true
            Write-Info 'WSL environment detected -- Recommend using install-linux.sh in WSL instead'
            $reply = Read-Host 'Continue installing in Windows? (Y/n)'
            if ($reply -eq 'n' -or $reply -eq 'N') { exit 0 }
        }
    }
    catch { }
}

# --- User-space directories ---
$UserBin = Join-Path $env:USERPROFILE '.local\bin'
$NpmGlobal = Join-Path $env:USERPROFILE '.npm-global'
if (-not (Test-Path $UserBin)) { New-Item -ItemType Directory -Path $UserBin -Force | Out-Null }
if (-not (Test-Path $NpmGlobal)) { New-Item -ItemType Directory -Path $NpmGlobal -Force | Out-Null }

# =============================================================================
# Step 1: Check and Install Prerequisites (User-Space)
# =============================================================================
Write-Step 'Step 1: Check and Install Prerequisites (User-Space)'

# 1.1 PowerShell version
$psVer = $PSVersionTable.PSVersion
if ($psVer.Major -lt 5) {
    Write-Err "Requires PowerShell 5.1 or higher (current: $psVer)`nDownload PowerShell Core: https://aka.ms/powershell"
}
Write-Ok "PowerShell $psVer"

# 1.2 Internet connection (with proxy support)
try {
    $proxy = [System.Net.WebProxy]::GetDefaultProxy()
    if ($proxy -and $proxy.Address) {
        Write-Info "System proxy detected: $($proxy.Address)"
        $global:PSDefaultParameterValues = @{
            'Invoke-WebRequest:Proxy' = $proxy.Address
            'Invoke-WebRequest:ProxyUseDefaultCredentials' = $true
        }
    }

    $testConn = Invoke-WebRequest -Uri 'https://github.com' -UseBasicParsing -TimeoutSec 15 -ErrorAction Stop
    Write-Ok 'Internet connection OK'
}
catch {
    Write-Err "Cannot connect to the internet.`nPlease check your Internet / Firewall / Proxy settings."
}

# 1.3 Git (user-space)
$gitCmd = Get-Command git -ErrorAction SilentlyContinue
if (-not $gitCmd) {
    Write-Warn 'git not found -- Installing in user-space...'

    $gitDir = Join-Path $env:USERPROFILE '.local\git'
    if (-not (Test-Path $gitDir)) { New-Item -ItemType Directory -Path $gitDir -Force | Out-Null }

    $gitUrl = 'https://github.com/git-for-windows/git/releases/download/v2.47.1.windows.2/PortableGit-2.47.1.2-64-bit.7z.exe'
    $gitExe = Join-Path $gitDir 'PortableGit.7z.exe'

    Write-Info 'Downloading Git Portable (this may take 1-2 minutes)...'
    try {
        Invoke-WebRequest -Uri $gitUrl -OutFile $gitExe -UseBasicParsing
        Write-Info 'Extracting Git...'
        $extractArgs = "-o`"$gitDir`" -y"
        Start-Process -FilePath $gitExe -ArgumentList $extractArgs -Wait -NoNewWindow

        $gitBin = Join-Path $gitDir 'bin'
        $gitCmdDir = Join-Path $gitDir 'cmd'
        $env:Path = $gitBin + ';' + $gitCmdDir + ';' + $env:Path

        $userPath = [System.Environment]::GetEnvironmentVariable('Path', 'User')
        if ($userPath -notlike "*$gitDir*") {
            [System.Environment]::SetEnvironmentVariable('Path', ($gitBin + ';' + $gitCmdDir + ';' + $userPath), 'User')
        }

        Remove-Item $gitExe -Force -ErrorAction SilentlyContinue
        Write-Ok 'Git Portable installed'

        $env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')
    }
    catch {
        Write-Err "Git download failed: $_"
    }
}
else {
    $gitVer = (git --version) -replace 'git version ', ''
    Write-Ok "git $gitVer"
}

# 1.4 Node.js v22+ (user-space)
$env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')

$nodeCmd = Get-Command node -ErrorAction SilentlyContinue
if (-not $nodeCmd) {
    Write-Warn 'Node.js not found -- Installing in user-space...'

    $nodeDir = Join-Path $env:USERPROFILE '.local\node'
    if (-not (Test-Path $nodeDir)) { New-Item -ItemType Directory -Path $nodeDir -Force | Out-Null }

    $nodeUrl = 'https://nodejs.org/dist/v22.22.0/node-v22.22.0-win-x64.zip'
    $nodeZip = Join-Path $nodeDir 'node.zip'

    Write-Info 'Downloading Node.js v22 portable (this may take 2-3 minutes)...'
    try {
        Invoke-WebRequest -Uri $nodeUrl -OutFile $nodeZip -UseBasicParsing
        Write-Info 'Extracting Node.js...'
        Expand-Archive -Path $nodeZip -DestinationPath $nodeDir -Force

        $nodeSubDir = Get-ChildItem -Path $nodeDir -Directory | Where-Object { $_.Name -like 'node-v*' } | Select-Object -First 1
        if ($nodeSubDir) {
            Get-ChildItem -Path $nodeSubDir.FullName | Copy-Item -Destination $nodeDir -Recurse -Force
            Remove-Item -Path $nodeSubDir.FullName -Recurse -Force
        }

        Remove-Item -Path $nodeZip -Force
        Get-ChildItem -Path $nodeDir -Filter "*.ps1" -Recurse | Remove-Item -Force -ErrorAction SilentlyContinue

        $env:Path = $nodeDir + ';' + $env:Path
        $userPath = [System.Environment]::GetEnvironmentVariable('Path', 'User')
        if ($userPath -notlike "*$nodeDir*") {
            [System.Environment]::SetEnvironmentVariable('Path', ($nodeDir + ';' + $userPath), 'User')
        }

        Write-Ok 'Node.js v22 portable installed'
    }
    catch {
        Write-Err "Node.js installation failed: $_"
    }
}

$nodeCmd = Get-Command node -ErrorAction SilentlyContinue
if ($nodeCmd) {
    $nodeVer = (node --version) -replace 'v', ''
    $nodeMajor = [int]($nodeVer -split '\.')[0]

    if ($nodeMajor -lt 22) {
        Write-Err "Node.js must be v22 or higher (current: v$nodeVer)"
    }
    Write-Ok "Node.js v$nodeVer"

    $npmCmd = Get-Command npm.cmd -ErrorAction SilentlyContinue
    if (-not $npmCmd) {
        $npmCmd = Get-Command npm -ErrorAction SilentlyContinue
    }
    if (-not $npmCmd) {
        Write-Err 'npm not found -- Reinstalling Node.js'
    }
    $npmVer = npm.cmd --version
    Write-Ok "npm $npmVer"
}
else {
    Write-Err 'Node.js installation failed'
}

# 1.5 Python 3.11 (user-space)
$env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')

$pythonIsValid = Test-PythonValid
if (-not $pythonIsValid) {
    Write-Warn 'Python 3 not found -- Installing in user-space...'

    $pythonDir = Join-Path $env:USERPROFILE '.local\python'
    if (-not (Test-Path $pythonDir)) { New-Item -ItemType Directory -Path $pythonDir -Force | Out-Null }

    $pythonUrl = 'https://www.python.org/ftp/python/3.11.9/python-3.11.9-embed-amd64.zip'
    $pythonZip = Join-Path $pythonDir 'python.zip'

    Write-Info 'Downloading Python embeddable...'
    try {
        Invoke-WebRequest -Uri $pythonUrl -OutFile $pythonZip -UseBasicParsing
        Write-Info 'Extracting Python...'
        Expand-Archive -Path $pythonZip -DestinationPath $pythonDir -Force
        Remove-Item -Path $pythonZip -Force

        $pthFile = Join-Path $pythonDir 'python311._pth'
        if (Test-Path $pthFile) {
            $pthContent = Get-Content $pthFile
            $pthContent = $pthContent -replace '#import site', 'import site'
            [System.IO.File]::WriteAllText($pthFile, ($pthContent -join "`r`n"))
        }

        $getPipUrl = 'https://bootstrap.pypa.io/get-pip.py'
        $getPipFile = Join-Path $pythonDir 'get-pip.py'
        Remove-Item $getPipFile -Force -ErrorAction SilentlyContinue
        Start-Sleep -Milliseconds 500
        Invoke-WebRequest -Uri $getPipUrl -OutFile $getPipFile -UseBasicParsing

        $pythonExe = Join-Path $pythonDir 'python.exe'
        Start-Process -FilePath $pythonExe -ArgumentList $getPipFile -Wait -NoNewWindow

        $pythonScriptsDir = Join-Path $pythonDir 'Scripts'
        $env:Path = $pythonDir + ';' + $pythonScriptsDir + ';' + $env:Path
        $userPath = [System.Environment]::GetEnvironmentVariable('Path', 'User')
        if ($userPath -notlike "*$pythonDir*") {
            [System.Environment]::SetEnvironmentVariable('Path', ($pythonDir + ';' + $pythonScriptsDir + ';' + $userPath), 'User')
        }

        Write-Ok 'Python embeddable installed'
    }
    catch {
        Write-Err "Python installation failed: $_"
    }
}

$pythonIsValid = Test-PythonValid
if ($pythonIsValid) {
    $prevEAP = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    $pythonVer = (python --version 2>&1) -replace 'Python ', ''
    $ErrorActionPreference = $prevEAP
    Write-Ok "Python $pythonVer"
}
else {
    Write-Err 'Python installation failed'
}

# =============================================================================
# Step 2: Install uv (Python package manager)
# =============================================================================
Write-Step 'Step 2: Install uv (Python package manager)'

$env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')

$uvCmd = Get-Command uv -ErrorAction SilentlyContinue
if (-not $uvCmd) {
    Write-Warn 'uv not found -- Installing...'
    try {
        powershell -ExecutionPolicy ByPass -c 'irm https://astral.sh/uv/install.ps1 | iex'
        $env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')
        Write-Ok 'uv installed'
    }
    catch {
        Write-Warn 'uv installation failed -- Can install manually: irm https://astral.sh/uv/install.ps1 | iex'
    }
}
else {
    Write-Ok 'uv found'
}

# =============================================================================
# Step 2.5: Install Hermes Agent (git clone + development install)
# =============================================================================
Write-Step 'Step 2.5: Install Hermes Agent (full installation with UI)'

$env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')

$hermesCmd = Get-Command hermes -ErrorAction SilentlyContinue

if ($hermesCmd -and -not $SkipInstall -and -not $Force) {
    Write-Warn 'Found existing hermes installation'

    $hermesWorks = $false
    try {
        $testVer = & hermes --version 2>&1
        if ($LASTEXITCODE -eq 0 -and $testVer -notlike '*Error*' -and $testVer -notlike '*Traceback*') {
            $hermesWorks = $true
        }
    }
    catch { }

    if (-not $hermesWorks) {
        Write-Warn 'Existing hermes is broken -- Reinstalling...'
    }
    else {
        $reply = Read-Host 'Reinstall? (y/N)'
        if ($reply -ne 'y' -and $reply -ne 'Y') {
            Write-Info 'Skipping installation -- Using existing hermes'
            $SkipInstall = $true
        }
    }
}

if (-not $SkipInstall) {
    $hermesInstallDir = Join-Path $env:LOCALAPPDATA 'hermes\hermes-agent'

    Write-Info 'Installing hermes-agent with full UI support...'
    Write-Host ''

    # Helper: git clone with retry (handles antivirus/network issues)
    function Invoke-GitCloneWithRetry {
        param([string]$TargetDir, [int]$MaxRetries = 3)

        # Ensure git is available in PATH
        $env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')
        $gitAvailable = Get-Command git -ErrorAction SilentlyContinue
        if (-not $gitAvailable) {
            Write-Err "Git not found in PATH. Please install Git first."
            return $false
        }

        for ($attempt = 1; $attempt -le $MaxRetries; $attempt++) {
            Write-Info "  Clone attempt $attempt of $MaxRetries..."
            # Use 2>$null to suppress git stderr (progress output), check LASTEXITCODE for success
            & git clone --depth 1 https://github.com/NousResearch/hermes-agent.git $TargetDir 2>$null
            if ($LASTEXITCODE -eq 0) { return $true }
            if ($attempt -lt $MaxRetries) {
                $delay = $attempt * 10
                Write-Warn "  Clone failed (exit code $LASTEXITCODE) -- Retrying in $delay seconds..."
                Start-Sleep -Seconds $delay
                # Clean up failed clone attempt
                if (Test-Path $TargetDir) {
                    Remove-Item $TargetDir -Recurse -Force -ErrorAction SilentlyContinue
                    Start-Sleep -Seconds 2
                }
            }
        }
        return $false
    }

    if (Test-Path $hermesInstallDir) {
        Write-Info 'Updating existing hermes-agent repository...'
        $updateOk = $false
        try {
            Push-Location $hermesInstallDir
            git pull origin main 2>&1 | Out-Null
            Pop-Location
            Write-Ok 'Repository updated'
            $updateOk = $true
        }
        catch {
            Write-Warn 'Git pull failed -- Reinstalling...'
            try { Pop-Location } catch { }

            # Kill any git processes that might be holding the directory
            Get-Process git -ErrorAction SilentlyContinue | Stop-Process -Force -ErrorAction SilentlyContinue
            Start-Sleep -Seconds 2

            # Remove directory with retry (use robocopy for ALL node_modules)
            $retryCount = 0
            while ((Test-Path $hermesInstallDir) -and ($retryCount -lt 5)) {
                try {
                    $nodeModulesPaths = @(
                        (Join-Path $hermesInstallDir 'node_modules'),
                        (Join-Path $hermesInstallDir 'web\node_modules'),
                        (Join-Path $hermesInstallDir 'apps\desktop\node_modules'),
                        (Join-Path $hermesInstallDir 'ui-tui\node_modules')
                    )
                    $emptyDir = Join-Path $env:TEMP 'empty_dir_for_rmdir'
                    if (-not (Test-Path $emptyDir)) { New-Item -ItemType Directory -Path $emptyDir -Force | Out-Null }
                    foreach ($nm in $nodeModulesPaths) {
                        if (Test-Path $nm) {
                            cmd /c "robocopy `"$emptyDir`" `"$nm`" /MIR /NFL /NDL /NJH /NJS /nc /ns /np >nul 2>nul"
                        }
                    }
                    Remove-Item $emptyDir -Force -ErrorAction SilentlyContinue
                    Remove-Item $hermesInstallDir -Recurse -Force -ErrorAction Stop
                    break
                }
                catch {
                    $retryCount++
                    Start-Sleep -Seconds 3
                }
            }

            if (Test-Path $hermesInstallDir) {
                Write-Err "Cannot remove old hermes directory: $hermesInstallDir`nPlease close any running hermes processes and try again, or remove manually:`n  Remove-Item '$hermesInstallDir' -Recurse -Force"
            }
        }

        if (-not $updateOk) {
            Write-Info 'Cloning hermes-agent repository (fresh install)...'
            $cloneOk = Invoke-GitCloneWithRetry -TargetDir $hermesInstallDir
            if (-not $cloneOk) {
                Write-Err "Git clone failed after retries.`nPlease check your internet connection and try again."
            }
        }
    }
    else {
        Write-Info 'Cloning hermes-agent repository...'
        $hermesParentDir = Join-Path $env:LOCALAPPDATA 'hermes'
        if (-not (Test-Path $hermesParentDir)) {
            New-Item -ItemType Directory -Path $hermesParentDir -Force | Out-Null
        }
        $cloneOk = Invoke-GitCloneWithRetry -TargetDir $hermesInstallDir
        if (-not $cloneOk) {
            Write-Err "Git clone failed after retries.`nPlease check your internet connection and try again."
        }
    }

    $gitDir = Join-Path $hermesInstallDir '.git'
    if (-not (Test-Path $gitDir)) {
        Write-Err "Git clone failed -- hermes-agent directory is not a valid repository.`nTry removing it manually: Remove-Item '$hermesInstallDir' -Recurse -Force`nThen run this script again."
    }

    Write-Info 'Setting up Python environment...'
    try {
        Push-Location $hermesInstallDir

        Write-Info 'Checking Python 3.11...'
        $pythonInstalled = $false
        $pythonList = uv python list 2>&1
        if ($pythonList -match '3\.11') {
            Write-Ok 'Python 3.11 already installed'
            $pythonInstalled = $true
        }

        if (-not $pythonInstalled) {
            Write-Info 'Installing Python 3.11 via uv...'
            uv python install 3.11
            if ($LASTEXITCODE -ne 0) {
                Write-Err "Failed to install Python 3.11"
                throw "Python installation failed"
            }
            Write-Ok 'Python 3.11 installed'
        }

        $venvDir = Join-Path $hermesInstallDir 'venv'
        if (-not (Test-Path $venvDir)) {
            Write-Info 'Creating virtual environment with Python 3.11...'
            $pythonPath = uv python find 3.11
            & $pythonPath -m venv $venvDir
            if ($LASTEXITCODE -ne 0) {
                Write-Err "Failed to create virtual environment"
                throw "venv creation failed"
            }
            Write-Ok 'Virtual environment created'
        }

        $venvScripts = Join-Path $venvDir 'Scripts'
        $venvPythonPath = Join-Path $venvScripts 'python.exe'
        $env:Path = $venvScripts + ';' + $env:Path

        Write-Info 'Installing hermes-agent Python packages (using uv pip)...'
        $installSets = @('[all]', '[messaging,dashboard,ext]', '[messaging]', '')
        $pipOk = $false

        foreach ($extra in $installSets) {
            $package = if ($extra) { ".$extra" } else { "." }
            Write-Info "  Trying uv pip install -e $package..."
            uv pip install -e $package --python $venvPythonPath
            $exitCode = $LASTEXITCODE

            if ($exitCode -eq 0) {
                $pipOk = $true
                Write-Ok "Python packages installed ($package)"
                break
            } else {
                Write-Warn "  Failed with exit code $exitCode"
                if ($extra -ne '') {
                    Write-Info "  Trying smaller package set..."
                }
            }
        }

        if (-not $pipOk) {
            Write-Warn 'Python packages install had issues -- hermes may not work'
        }

        # Configure npm for corporate environments
        Write-Info 'Configuring npm for corporate environment...'
        cmd /c "npm.cmd config set maxsockets 3 2>nul"
        cmd /c "npm.cmd config set fetch-retries 5 2>nul"
        cmd /c "npm.cmd config set fetch-timeout 300000 2>nul"
        cmd /c "npm.cmd config set fetch-retry-mintimeout 10000 2>nul"
        cmd /c "npm.cmd config set fetch-retry-maxtimeout 120000 2>nul"

        Write-Info 'Installing Node.js dependencies (dashboard, desktop, TUI)...'
        Write-Info 'This may take 10-20 minutes on first run...'

        function Invoke-NpmWithRetry {
            param([string]$Command, [int]$MaxRetries = 5)
            $nodeModules = Join-Path $hermesInstallDir 'node_modules'
            for ($attempt = 1; $attempt -le $MaxRetries; $attempt++) {
                Write-Info "  Attempt $attempt of $MaxRetries..."
                cmd /c "$Command 2>nul 1>nul"
                if ($LASTEXITCODE -eq 0) { return $true }
                if ($attempt -lt $MaxRetries) {
                    $delay = $attempt * 15
                    Write-Warn "  npm failed (antivirus may be locking files) -- Retrying in $delay seconds..."
                    Start-Sleep -Seconds $delay
                    if (Test-Path $nodeModules) {
                        Remove-Item $nodeModules -Recurse -Force -ErrorAction SilentlyContinue
                        Start-Sleep -Seconds 5
                    }
                }
            }
            return $false
        }

        $npmOk = Invoke-NpmWithRetry -Command 'npm.cmd install --no-fund --no-audit'
        if (-not $npmOk) {
            Write-Warn 'npm install failed -- Falling back to npm ci...'
            $npmOk = Invoke-NpmWithRetry -Command 'npm.cmd ci --no-fund --no-audit'
        }
        if ($npmOk) {
            Write-Ok 'Node.js dependencies installed'
        }
        else {
            Write-Warn 'Node.js dependencies install had issues'
        }

        # Download Electron binary
        Write-Info 'Downloading Electron binary...'
        $electronInstall = Join-Path $hermesInstallDir 'node_modules\electron\install.js'
        if (Test-Path $electronInstall) {
            cmd /c "node `"$electronInstall`" 2>nul 1>nul"
            if ($LASTEXITCODE -eq 0) {
                Write-Ok 'Electron binary downloaded'
            }
            else {
                Write-Warn 'Electron download failed -- desktop may not work'
            }
        }

        # Build web workspace
        Write-Info 'Building web UI for dashboard...'
        $webNm = Join-Path $hermesInstallDir 'web\node_modules'
        if (-not (Test-Path $webNm)) {
            cmd /c "npm.cmd install --workspace web --no-fund --no-audit --prefer-offline 2>nul 1>nul"
        }
        $webBuildOk = $false
        for ($attempt = 1; $attempt -le 5; $attempt++) {
            cmd /c "npm.cmd run build -w web 2>nul 1>nul"
            if ($LASTEXITCODE -eq 0) { $webBuildOk = $true; break }
            if ($attempt -lt 5) {
                $delay = $attempt * 15
                Write-Warn "  Web build failed -- waiting ${delay}s..."
                Start-Sleep -Seconds $delay
            }
        }
        if ($webBuildOk) {
            Write-Ok 'Dashboard web UI built -- ready to use immediately'
        }
        else {
            Write-Warn 'Dashboard web UI build failed -- will build on first launch'
        }

        # Build TUI workspace
        Write-Info 'Installing TUI workspace (for embedded terminal)...'
        $tuiNm = Join-Path $hermesInstallDir 'ui-tui\node_modules'
        if (-not (Test-Path $tuiNm)) {
            cmd /c "npm.cmd install --workspace ui-tui --no-fund --no-audit --ignore-scripts --prefer-offline 2>nul 1>nul"
        }
        Write-Ok 'TUI workspace installed -- dashboard terminal will work'

        # Build desktop app
        Write-Info 'Pre-building desktop app (this may take 3-5 minutes)...'
        $desktopNm = Join-Path $hermesInstallDir 'apps\desktop\node_modules'
        if (-not (Test-Path $desktopNm)) {
            cmd /c "npm.cmd install --workspace apps/desktop --no-fund --no-audit --ignore-scripts --prefer-offline 2>nul 1>nul"
        }
        $desktopOk = $false
        for ($attempt = 1; $attempt -le 5; $attempt++) {
            cmd /c "npm.cmd run pack -w apps/desktop 2>nul 1>nul"
            if ($LASTEXITCODE -eq 0) { $desktopOk = $true; break }
            if ($attempt -lt 5) {
                $delay = $attempt * 15
                Write-Warn "  Failed -- waiting ${delay}s for antivirus..."
                Start-Sleep -Seconds $delay
                if (Test-Path $desktopNm) { Remove-Item $desktopNm -Recurse -Force -ErrorAction SilentlyContinue }
            }
        }
        if ($desktopOk) {
            Write-Ok 'Desktop app built -- hermes desktop will launch immediately'
        }
        else {
            Write-Warn 'Desktop pre-build skipped -- will build on first launch'
        }
        Pop-Location

        Pop-Location

        # Add hermes to PATH
        $hermesBin = Join-Path $venvScripts 'hermes.exe'
        if (Test-Path $hermesBin) {
            $userPath = [System.Environment]::GetEnvironmentVariable('Path', 'User')
            if ($userPath -notlike "*$venvScripts*") {
                [System.Environment]::SetEnvironmentVariable('Path', ($venvScripts + ';' + $userPath), 'User')
                $env:Path = $venvScripts + ';' + $env:Path
            }
            Write-Ok "hermes installed at: $hermesBin"
            Write-Ok 'UI components included (desktop, dashboard, TUI)'
        }
        else {
            Write-Warn 'hermes executable not found in venv'
        }

        # Remove embeddable Python from PATH
        $currentUserPath = [System.Environment]::GetEnvironmentVariable('Path', 'User')
        $pathParts = $currentUserPath -split ';' | Where-Object {
            $_ -ne '' -and $_ -notlike '*\.local\python*'
        }
        $cleanPath = $pathParts -join ';'
        if ($cleanPath -ne $currentUserPath) {
            [System.Environment]::SetEnvironmentVariable('Path', $cleanPath, 'User')
            Write-Ok 'Removed embeddable Python from PATH (gateway will use venv Python)'
        }
    }
    catch {
        Write-Err "Hermes installation failed: $_"
    }

    $env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')

    $hermesCmd = Get-Command hermes -ErrorAction SilentlyContinue
    if ($hermesCmd) {
        Write-Ok "hermes ready: $($hermesCmd.Source)"
    }
    else {
        Write-Warn 'hermes not in PATH yet -- Try opening new PowerShell and run script again'
    }
}

# =============================================================================
# Step 3: Install Antigravity CLI (agy)
# =============================================================================
Write-Step 'Step 3: Install Antigravity CLI (agy)'

$env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')

Write-Info 'Antigravity CLI (agy) uses Gemini free via Google Account'
Write-Info 'Good for fixing/repairing hermes when it has problems'
Write-Info '(Free tier has rate limit -- enough for fixing hermes)'

$agyCmd = Get-Command agy -ErrorAction SilentlyContinue
if ($agyCmd) {
    Write-Ok 'Found existing agy installation'
}
else {
    Write-Warn 'agy not found -- Installing...'

    try {
        $prevEAP = $ErrorActionPreference
        $ErrorActionPreference = 'Continue'
        irm https://antigravity.google/cli/install.ps1 | iex
        $ErrorActionPreference = $prevEAP
        $agyBin = Join-Path $env:LOCALAPPDATA 'agy\bin'
        $env:Path = $agyBin + ';' + $env:Path

        $userPath = [System.Environment]::GetEnvironmentVariable('Path', 'User')
        if ($userPath -notlike "*agy*") {
            [System.Environment]::SetEnvironmentVariable('Path', ($agyBin + ';' + $userPath), 'User')
        }

        Write-Ok "agy installed -> $agyBin"
        Write-Ok 'Start agy for first time to login with Google Account'
    }
    catch {
        Write-Warn 'agy installation failed -- Can install manually later:'
        Write-Host '  PowerShell: irm https://antigravity.google/cli/install.ps1 | iex' -ForegroundColor Yellow
    }
}

# =============================================================================
# Step 4: Ask for API Keys (OKMD primary, LiteLLM fallback)
# =============================================================================
Write-Step 'Step 4: Configure API Keys'

# Initialize model arrays
$OKMDModels = @()
$LiteLLMModels = @()

# 4.1 OKMD API Key (FREE - primary provider)
Write-Host ''
Write-Host '----------------------------------------------------------------' -ForegroundColor Cyan
Write-Host 'OKMD AI Playground - FREE Models (Recommended):' -ForegroundColor Yellow
Write-Host '----------------------------------------------------------------' -ForegroundColor Cyan
Write-Host ''
Write-Host '  สมัครฟรีที่: https://playground.okmd.or.th' -ForegroundColor White
Write-Host '  1. Login ด้วย Google Account' -ForegroundColor White
Write-Host '  2. ไปที่ Settings -> API Platform' -ForegroundColor White
Write-Host '  3. Generate API Key (ขึ้นต้นด้วย sk_...)' -ForegroundColor White
Write-Host '  4. Copy key มาวางด้านล่าง' -ForegroundColor White
Write-Host ''
Write-Host '  Free 23 models: deepseek-v4-flash, gpt-5.4-mini, llama-4-maverick, etc.' -ForegroundColor Green
Write-Host '  Quota: สูงสุด 1M tokens/day (share กันทั้ง Provider)' -ForegroundColor Green
Write-Host ''

$OKMDKey = Read-Host 'Paste OKMD API Key (or press Enter to skip)'

if (-not [string]::IsNullOrWhiteSpace($OKMDKey)) {
    Write-Ok 'Received OKMD API Key'

    # Query available models from OKMD
    Write-Info 'Querying available models from OKMD...'
    try {
        $headers = @{ 'Authorization' = "Bearer $OKMDKey" }
        $modelsResponse = Invoke-WebRequest -Uri 'https://gen.ai.kku.ac.th/okmd/api/v1/models' -Headers $headers -UseBasicParsing -TimeoutSec 15
        $modelsData = $modelsResponse.Content | ConvertFrom-Json
        if ($modelsData.data) {
            foreach ($m in $modelsData.data) {
                if ($m.id) {
                    $OKMDModels += $m.id
                }
            }
        }
        if ($OKMDModels.Count -gt 0) {
            Write-Ok "Found $($OKMDModels.Count) free models: $($OKMDModels -join ', ')"
        }
        else {
            Write-Warn 'No models returned -- Using default model list'
        }
    }
    catch {
        Write-Warn "Failed to query OKMD models: $_ -- Using default model list"
    }
}
else {
    Write-Warn 'Skipping OKMD API Key -- Will use LiteLLM fallback'
}

# 4.2 LiteLLM API Key (Course 0 - fallback provider)
Write-Host ''
Write-Host '----------------------------------------------------------------' -ForegroundColor Cyan
Write-Host 'LiteLLM Proxy - Course 0 (Fallback):' -ForegroundColor Yellow
Write-Host '----------------------------------------------------------------' -ForegroundColor Cyan
Write-Host ''
Write-Host '  Base URL: https://litellm-proxy-gateway.pbseiyacpro7.workers.dev/v1' -ForegroundColor White
Write-Host '  Model: qwen3.7-plus' -ForegroundColor White
Write-Host '  สำหรับนักเรียน Course 0 ที่ได้รับ API Key จาก instructor' -ForegroundColor White
Write-Host ''

$LiteLLMKey = Read-Host 'Paste LiteLLM API Key (or press Enter to skip)'

if (-not [string]::IsNullOrWhiteSpace($LiteLLMKey)) {
    Write-Ok 'Received LiteLLM API Key'

    Write-Info 'Querying available models from LiteLLM proxy...'
    try {
        $headers = @{ 'Authorization' = "Bearer $LiteLLMKey" }
        $modelsResponse = Invoke-WebRequest -Uri 'https://litellm-proxy-gateway.pbseiyacpro7.workers.dev/v1/models' -Headers $headers -UseBasicParsing -TimeoutSec 15
        $modelsData = $modelsResponse.Content | ConvertFrom-Json
        if ($modelsData.data) {
            foreach ($m in $modelsData.data) {
                if ($m.id) {
                    $LiteLLMModels += $m.id
                }
            }
        }
        if ($LiteLLMModels.Count -gt 0) {
            Write-Ok "Found $($LiteLLMModels.Count) models: $($LiteLLMModels -join ', ')"
        }
        else {
            Write-Warn 'No models returned -- Using default model list'
        }
    }
    catch {
        Write-Warn "Failed to query models: $_ -- Using default model list"
    }
}
else {
    Write-Warn 'Skipping LiteLLM API Key -- Can use hermes setup later'
}

# 4.3 Telegram Bot Token
Write-Host ''
Write-Host '----------------------------------------------------------------' -ForegroundColor Cyan
Write-Host 'Create Telegram Bot Token (follow Slide Module 02):' -ForegroundColor Yellow
Write-Host '----------------------------------------------------------------' -ForegroundColor Cyan
Write-Host ''
Write-Host '  1. Open Telegram and search for @BotFather' -ForegroundColor White
Write-Host '  2. Send command /newbot' -ForegroundColor White
Write-Host '  3. Name the bot (e.g., Hermes Assistant)' -ForegroundColor White
Write-Host '  4. Set username (e.g., my_hermes_bot)' -ForegroundColor White
Write-Host '  5. Copy token from BotFather (format: 123456789:ABCdefGHI...)' -ForegroundColor Cyan
Write-Host ''

$TelegramToken = Read-Host 'Paste Telegram Bot Token (or press Enter to skip)'

$TelegramChatId = ''
if (-not [string]::IsNullOrWhiteSpace($TelegramToken)) {
    if ($TelegramToken -notmatch '^\d+:[A-Za-z0-9_-]+$') {
        Write-Warn 'Invalid token -- Please check again (should be 123456789:ABCdef...)'
    }
    else {
        Write-Ok 'Received Telegram Bot Token'

        Write-Host ''
        Write-Host '----------------------------------------------------------------' -ForegroundColor Cyan
        Write-Host 'Find your Telegram Chat ID (so ONLY you can use the bot):' -ForegroundColor Yellow
        Write-Host '----------------------------------------------------------------' -ForegroundColor Cyan
        Write-Host ''
        Write-Host '  1. Open Telegram and search for @userinfobot' -ForegroundColor White
        Write-Host '  2. Press Start or send /start' -ForegroundColor White
        Write-Host '  3. It will reply with your Id: (a number like 123456789)' -ForegroundColor Cyan
        Write-Host ''

        $TelegramChatId = Read-Host 'Paste your Chat ID number (or press Enter to skip)'

        if (-not [string]::IsNullOrWhiteSpace($TelegramChatId)) {
            if ($TelegramChatId -match '^\d+$') {
                Write-Ok "Chat ID set: $TelegramChatId -- Only you can use the bot"
            }
            else {
                Write-Warn 'Invalid Chat ID (should be numbers only) -- Skipping'
                $TelegramChatId = ''
            }
        }
        else {
            Write-Warn 'Skipping Chat ID -- Bot will not respond until you configure TELEGRAM_ALLOWED_USERS'
        }
    }
}
else {
    Write-Warn 'Skipping Telegram setup -- Can use hermes gateway setup later'
}

# =============================================================================
# Step 5: Configure Hermes
# =============================================================================
Write-Step 'Step 5: Configure Hermes'

$hermesDir = Join-Path $env:LOCALAPPDATA 'hermes'
if (-not (Test-Path $hermesDir)) {
    New-Item -ItemType Directory -Path $hermesDir -Force | Out-Null
}

$logsDir = Join-Path $hermesDir 'logs'
if (-not (Test-Path $logsDir)) {
    New-Item -ItemType Directory -Path $logsDir -Force | Out-Null
}

$envFile = Join-Path $hermesDir '.env'

if (Test-Path $envFile) {
    $backupFile = $envFile + '.backup.' + (Get-Date -Format 'yyyyMMddHHmmss')
    Copy-Item $envFile $backupFile
    Write-Info "Backed up original .env to $backupFile"
}

# Determine primary provider
$primaryProvider = 'okmd'
$primaryKey = $OKMDKey
$primaryModels = $OKMDModels
$primaryBaseUrl = 'https://gen.ai.kku.ac.th/okmd/api/v1'
$primaryDefaultModel = 'deepseek-v4-flash'

if ([string]::IsNullOrWhiteSpace($OKMDKey) -and -not [string]::IsNullOrWhiteSpace($LiteLLMKey)) {
    $primaryProvider = 'litellm'
    $primaryKey = $LiteLLMKey
    $primaryModels = $LiteLLMModels
    $primaryBaseUrl = 'https://litellm-proxy-gateway.pbseiyacpro7.workers.dev/v1'
    $primaryDefaultModel = 'qwen3.7-plus'
}

# Create .env
$envContent = @"
# Hermes Agent Environment Variables
# Configured by install-windows.ps1 at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')

# Primary Provider: OKMD AI Playground (Free Models)
OKMD_API_KEY=$OKMDKey

# Fallback Provider: LiteLLM Proxy (Course 0)
LITELLM_API_KEY=$LiteLLMKey

# Telegram Bot Token
TELEGRAM_BOT_TOKEN=$TelegramToken

# Telegram Authorization (only your Chat ID can use the bot)
TELEGRAM_ALLOWED_USERS=$TelegramChatId

# Force gateway to use venv Python (not embeddable/system Python)
HERMES_PYTHON=$venvPythonPath
"@

[System.IO.File]::WriteAllText($envFile, $envContent, [System.Text.UTF8Encoding]::new($false))
Write-Ok 'Created .env with API keys'

# Create config.yaml
$configFile = Join-Path $hermesDir 'config.yaml'
if (Test-Path $configFile) {
    $backupConfig = $configFile + '.backup.' + (Get-Date -Format 'yyyyMMddHHmmss')
    Copy-Item $configFile $backupConfig
    Write-Info 'Backed up original config.yaml'
}

# Build models section
$modelsSection = ""
if ($primaryModels.Count -gt 0) {
    foreach ($modelId in $primaryModels) {
        $modelsSection += "      ${modelId}:`n"
        $modelsSection += "        context_length: 1000000`n"
    }
}
else {
    # Default OKMD models
    $defaultModels = @(
        'deepseek-v4-flash', 'deepseek-v4-pro',
        'gpt-5.4', 'gpt-5.4-mini', 'gpt-5.4-nano',
        'gemini-3.5-flash', 'gemini-3.1-flash-lite', 'gemini-2.5-flash-lite',
        'llama-4-maverick', 'llama-4-scout',
        'nova-pro-v1', 'nova-2-lite-v1',
        'claude-sonnet-5', 'claude-sonnet-4.6',
        'grok-4.3', 'sonar-pro',
        'qwen3.7-plus', 'qwen3.7-max', 'qwen3.6-flash',
        'mistral-medium-3.1'
    )
    foreach ($modelId in $defaultModels) {
        $modelsSection += "      ${modelId}:`n"
        $modelsSection += "        context_length: 1000000`n"
    }
}

$configContent = @"
# Hermes Agent Configuration
# Configured by install-windows.ps1 at $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')
# Primary Provider: $primaryProvider (Free Models)

model:
  provider: $primaryProvider
  default: $primaryDefaultModel
  base_url: $primaryBaseUrl

providers:
  $primaryProvider`:
    api_key: $primaryKey
    base_url: $primaryBaseUrl
    default_model: $primaryDefaultModel
    models:
$($modelsSection)    transport: openai_chat

# Dashboard
dashboard:
  enabled: true
  port: 9119

# Security & Permissions
approvals:
  mode: off

# Telegram Gateway
telegram:
  reactions: true

security:
  redact_secrets: false

privacy:
  redact_pii: false
"@

[System.IO.File]::WriteAllText($configFile, $configContent, [System.Text.UTF8Encoding]::new($false))
if ($primaryModels.Count -gt 0) {
    Write-Ok "Create config.yaml ($primaryProvider + $($primaryModels.Count) models)"
}
else {
    Write-Ok "Create config.yaml ($primaryProvider + default models)"
}
Write-Ok 'Configured: approvals=off, reactions=true, redact_secrets=false, redact_pii=false'
Write-Ok 'Dashboard: http://localhost:9119'

# =============================================================================
# Step 6: Configure Auto-Start after reboot
# =============================================================================
Write-Step 'Step 6: Configure Auto-Start after reboot'

$env:Path = [System.Environment]::GetEnvironmentVariable('Path', 'Machine') + ';' + [System.Environment]::GetEnvironmentVariable('Path', 'User')

$hermesCmd = Get-Command hermes -ErrorAction SilentlyContinue
$hermesBin = $null
if ($hermesCmd) {
    $hermesBin = $hermesCmd.Source
}
else {
    $fallbackHermes = Join-Path $env:LOCALAPPDATA 'hermes\hermes-agent\venv\Scripts\hermes.exe'
    if (Test-Path $fallbackHermes) {
        $hermesBin = $fallbackHermes
    }
}

if (-not $hermesBin) {
    Write-Warn 'hermes executable not found -- Skipping auto-start setup'
}
else {
    Write-Info "Found hermes at: $hermesBin"

    $startupDir = Join-Path $env:LOCALAPPDATA 'hermes\startup'
    if (-not (Test-Path $startupDir)) {
        New-Item -ItemType Directory -Path $startupDir -Force | Out-Null
    }

    $gatewayBat = Join-Path $startupDir 'hermes-gateway.bat'
    $nodeDir = Join-Path $env:USERPROFILE '.local\node'
    $gatewayContent = "@echo off`r`nset PATH=$nodeDir;$venvScripts;%PATH%`r`nset HERMES_HOME=$env:LOCALAPPDATA\hermes`r`necho [%date% %time%] Starting Hermes Gateway... >> `"%LOCALAPPDATA%\hermes\logs\gateway-startup.log`"`r`nstart /B `"`" `"$venvPythonPath`" -m hermes_cli.main gateway run >> `"%LOCALAPPDATA%\hermes\logs\gateway-startup.log`" 2>&1"
    [System.IO.File]::WriteAllText($gatewayBat, $gatewayContent)

    $dashboardBat = Join-Path $startupDir 'hermes-dashboard.bat'
    $dashboardContent = "@echo off`r`nset PATH=$nodeDir;$venvScripts;%PATH%`r`nset HERMES_HOME=$env:LOCALAPPDATA\hermes`r`necho [%date% %time%] Starting Hermes Dashboard... >> `"%LOCALAPPDATA%\hermes\logs\dashboard-startup.log`"`r`n`"$hermesBin`" dashboard --no-open >> `"%LOCALAPPDATA%\hermes\logs\dashboard-startup.log`" 2>&1"
    [System.IO.File]::WriteAllText($dashboardBat, $dashboardContent)

    $desktopBat = Join-Path $startupDir 'hermes-desktop.bat'
    $desktopContent = "@echo off`r`nset `"PATH=$venvScripts;%PATH%`"`r`n`"$hermesBin`" desktop -- --password-store=basic --disable-gpu-sandbox"
    [System.IO.File]::WriteAllText($desktopBat, $desktopContent)
    Write-Ok 'Desktop launcher created (with DPAPI workaround for managed computers)'

    try {
        schtasks /Delete /TN 'HermesGateway' /F 2>$null
        schtasks /Delete /TN 'HermesDashboard' /F 2>$null

        $action = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument ('/c "' + $gatewayBat + '"')
        $trigger = New-ScheduledTaskTrigger -AtLogOn
        $trigger.Delay = 'PT30S'
        $settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable
        $principal = New-ScheduledTaskPrincipal -UserId $env:USERNAME -LogonType Interactive -RunLevel Limited

        Register-ScheduledTask -TaskName 'HermesGateway' -Action $action -Trigger $trigger -Settings $settings -Principal $principal -Description 'Hermes Agent Telegram Gateway' -Force | Out-Null

        $action2 = New-ScheduledTaskAction -Execute 'cmd.exe' -Argument ('/c "' + $dashboardBat + '"')
        $trigger2 = New-ScheduledTaskTrigger -AtLogOn
        $trigger2.Delay = 'PT60S'

        Register-ScheduledTask -TaskName 'HermesDashboard' -Action $action2 -Trigger $trigger2 -Settings $settings -Principal $principal -Description 'Hermes Agent Web Dashboard' -Force | Out-Null

        Write-Ok 'Create Windows Task Scheduler tasks'
        Write-Ok '  - HermesGateway (Telegram)'
        Write-Ok '  - HermesDashboard (Dashboard)'
        Write-Info 'Start services with: schtasks /Run /TN "HermesGateway" && schtasks /Run /TN "HermesDashboard"'
    }
    catch {
        Write-Warn 'Task Scheduler creation failed -- Using Startup Folder instead'

        $shell = New-Object -ComObject WScript.Shell
        $startupFolder = [System.Environment]::GetFolderPath('Startup')

        $gwShortcut = $shell.CreateShortcut((Join-Path $startupFolder 'HermesGateway.lnk'))
        $gwShortcut.TargetPath = $gatewayBat
        $gwShortcut.WorkingDirectory = $startupDir
        $gwShortcut.Save()

        $dbShortcut = $shell.CreateShortcut((Join-Path $startupFolder 'HermesDashboard.lnk'))
        $dbShortcut.TargetPath = $dashboardBat
        $dbShortcut.WorkingDirectory = $startupDir
        $dbShortcut.Save()

        Write-Ok 'Created shortcuts in Startup Folder'
        Write-Ok '  - HermesGateway.lnk'
        Write-Ok '  - HermesDashboard.lnk'
    }
}

# =============================================================================
# Step 7: Start Telegram Gateway
# =============================================================================
Write-Step 'Step 7: Start Telegram Gateway'

if (-not [string]::IsNullOrWhiteSpace($TelegramToken)) {
    Write-Info 'Starting Telegram Gateway...'
    try {
        $hermesCmd = Get-Command hermes -ErrorAction SilentlyContinue
        if ($hermesCmd) {
            Start-Process -FilePath $hermesCmd.Source -ArgumentList 'gateway', 'start' -WindowStyle Hidden
            Start-Sleep -Seconds 3
            Write-Ok 'Telegram Gateway started'
        }
        else {
            Write-Warn 'hermes command not found -- Run: hermes gateway start'
        }
    }
    catch {
        Write-Warn 'Gateway failed to start -- Run: hermes gateway start'
    }
}
else {
    Write-Warn 'Telegram not configured -- Run: hermes gateway setup'
}

# =============================================================================
# Installation Summary
# =============================================================================
Write-Host ''
Write-Host '============================================================' -ForegroundColor Green
Write-Host '                  Installation Complete!                    ' -ForegroundColor Green
Write-Host '============================================================' -ForegroundColor Green
Write-Host ''
Write-Host 'Installed in user-space (No Admin required):' -ForegroundColor Cyan
Write-Host '  - Node.js v22+ -> ~/.local/node/' -ForegroundColor White
Write-Host '  - Python 3.11+ -> ~/.local/python/' -ForegroundColor White
Write-Host '  - uv -> ~/.local/bin/' -ForegroundColor White
Write-Host '  - Hermes -> %LOCALAPPDATA%\hermes\hermes-agent (git clone)' -ForegroundColor White
Write-Host '  - agy -> ~/AppData/Local/agy/bin/' -ForegroundColor White
Write-Host ''
Write-Host 'Configuration:' -ForegroundColor Cyan
if ($primaryProvider -eq 'okmd') {
    Write-Host "  - Primary: OKMD AI Playground (Free Models)" -ForegroundColor Green
    Write-Host "  - Models: $($OKMDModels.Count) free models available" -ForegroundColor White
}
else {
    Write-Host "  - Primary: LiteLLM Proxy (Course 0)" -ForegroundColor Yellow
    Write-Host "  - Models: $($LiteLLMModels.Count) models available" -ForegroundColor White
}
Write-Host '  - Dashboard: http://localhost:9119' -ForegroundColor White
Write-Host '  - Telegram: Ready to use' -ForegroundColor White
Write-Host '  - Auto-start: After login' -ForegroundColor White
Write-Host ''
Write-Host 'Commands to use:' -ForegroundColor Cyan
Write-Host '  hermes                          Start Hermes CLI (chat)' -ForegroundColor White
Write-Host '  hermes model                    Change model' -ForegroundColor White
Write-Host '  hermes doctor                   Diagnose problems' -ForegroundColor White
Write-Host ''
Write-Host 'Start Telegram Gateway + Dashboard:' -ForegroundColor Cyan
Write-Host '  schtasks /Run /TN "HermesGateway"' -ForegroundColor White
Write-Host '  schtasks /Run /TN "HermesDashboard"' -ForegroundColor White
Write-Host ''
Write-Host 'Test functionality:' -ForegroundColor Cyan
Write-Host '  hermes                          Start Hermes CLI (chat)' -ForegroundColor White
Write-Host '  hermes dashboard                Open web dashboard' -ForegroundColor White
Write-Host '  hermes desktop                  Open desktop app' -ForegroundColor White
Write-Host ''
Write-Host 'If dashboard/desktop fails (antivirus issue):' -ForegroundColor Yellow
Write-Host '  1. Temporarily disable antivirus real-time protection' -ForegroundColor White
Write-Host '  2. Open PowerShell and run:' -ForegroundColor White
Write-Host '     cd $env:LOCALAPPDATA\hermes\hermes-agent' -ForegroundColor White
Write-Host '     npm install --no-fund --no-audit' -ForegroundColor White
Write-Host '     npm install --workspace web --no-fund --no-audit' -ForegroundColor White
Write-Host '     npm run build -w web' -ForegroundColor White
Write-Host '  3. Re-enable antivirus' -ForegroundColor White
Write-Host '  4. Try hermes dashboard / hermes desktop again' -ForegroundColor White
Write-Host ''
Write-Host 'Ready to start Course 0: Hermes + AI Harness!' -ForegroundColor Green
Write-Host ''

$null = Read-Host 'Press Enter to close this window'
