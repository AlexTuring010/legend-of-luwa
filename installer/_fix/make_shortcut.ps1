param(
    [Parameter(Mandatory=$true)][string]$GameDir,
    [string]$DesktopOverride
)
# Creates a "Legend of LuWa" desktop shortcut IF one does not already exist.
# Called by the installer batch as a fallback in case setup.exe did not make one.
$ErrorActionPreference = 'SilentlyContinue'

$game = Join-Path $GameDir 'Luwa.exe'
if (-not (Test-Path $game)) {
    Write-Output "SKIP: Luwa.exe not found in $GameDir"
    return
}

if ($DesktopOverride) {
    # test / manual override: use one explicit folder for both checking and creating
    $createDir = $DesktopOverride
    $checkDirs = @($DesktopOverride)
} else {
    # real run: create on the all-users (Public) desktop, same place setup.exe uses;
    # check both the Public desktop and the current user's desktop to avoid duplicates
    $createDir = [Environment]::GetFolderPath('CommonDesktopDirectory')
    $checkDirs = @(
        [Environment]::GetFolderPath('CommonDesktopDirectory'),
        [Environment]::GetFolderPath('DesktopDirectory')
    ) | Where-Object { $_ -and (Test-Path $_) } | Select-Object -Unique
}

# already have a Luwa shortcut? then do nothing (no duplicates)
$existing = @()
foreach ($d in $checkDirs) {
    $existing += Get-ChildItem -Path $d -Filter '*Luwa*.lnk' -ErrorAction SilentlyContinue
}
if ($existing.Count -gt 0) {
    Write-Output ("EXISTS: " + $existing[0].FullName)
    return
}

if (-not (Test-Path $createDir)) { New-Item -ItemType Directory -Force -Path $createDir | Out-Null }
$dest = Join-Path $createDir 'Legend of LuWa.lnk'
$w = New-Object -ComObject WScript.Shell
$lnk = $w.CreateShortcut($dest)
$lnk.TargetPath = $game
$lnk.WorkingDirectory = $GameDir
$lnk.IconLocation = "$game,0"
$lnk.Description = 'Legend of LuWa'
$lnk.Save()
Write-Output ("MADE: " + $dest)
