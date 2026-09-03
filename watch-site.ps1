<#
.SYNOPSIS
  Keeps https://inpani.pk (GitHub Pages) in step with this folder, automatically.

  Two jobs, every cycle:
    1. If a newer APK has appeared in Desktop\Inpani, copy it into downloads\ and correct the
       file sizes printed on the page.
    2. If anything here differs from the last push - the APKs above, or an edit you made to
       index.html - commit and push it. GitHub Pages redeploys within about a minute.

  Started at logon by the "Inpani site auto-publish" scheduled task.
  Run by hand to watch in the foreground:  .\watch-site.ps1 -Verbose

.NOTES
  Polls rather than using FileSystemWatcher: a 49 MB APK takes seconds to copy and an event
  fires the moment the file APPEARS, not when it is complete. Requiring the size to hold steady
  is what stops a half-written APK being published to real users.
#>
param(
    [int]$PollSeconds = 60,
    [int]$SettleSeconds = 30,
    [string]$BuildDir = "C:\Users\bilal\Desktop\Inpani"
)

$ErrorActionPreference = "Stop"
Set-Location $PSScriptRoot

$log = Join-Path $PSScriptRoot "watcher.log"
function Write-Log($msg) {
    $line = "{0}  {1}" -f (Get-Date -Format "yyyy-MM-dd HH:mm:ss"), $msg
    Add-Content -Path $log -Value $line -Encoding utf8
    Write-Verbose $line
}

function Get-Sha($path) {
    if (-not (Test-Path $path)) { return $null }
    (Get-FileHash -Path $path -Algorithm SHA256).Hash
}

# Copy any APK that differs from what the site is serving. Returns the names that changed.
function Sync-Apks {
    $changed = @()
    foreach ($name in @("Inpani-Customer.apk", "Inpani-Driver.apk")) {
        $src = Join-Path $BuildDir $name
        $dst = Join-Path $PSScriptRoot "downloads\$name"
        if (-not (Test-Path $src)) { continue }
        if ((Get-Sha $src) -ne (Get-Sha $dst)) {
            Copy-Item $src $dst -Force
            $changed += $name
        }
    }
    return $changed
}

# The page states each APK's size in megabytes; a stale figure is a small lie to visitors.
function Update-Sizes {
    $page = Join-Path $PSScriptRoot "index.html"
    $html = Get-Content $page -Raw
    $c = [math]::Round((Get-Item "downloads\Inpani-Customer.apk").Length / 1MB, 1)
    $d = [math]::Round((Get-Item "downloads\Inpani-Driver.apk").Length / 1MB, 1)
    $html = [regex]::Replace($html, 'For customers . Android . [\d.]+ MB', "For customers &#183; Android &#183; $c MB")
    $html = [regex]::Replace($html, 'For drivers . Android . [\d.]+ MB',   "For drivers &#183; Android &#183; $d MB")
    Set-Content $page $html -Encoding utf8 -NoNewline
}

function Get-PendingState {
    $porcelain = git status --porcelain
    if (-not $porcelain) { return $null }
    $state = @{}
    foreach ($line in $porcelain) {
        $path = $line.Substring(3).Trim('"')
        $full = Join-Path $PSScriptRoot $path
        if (Test-Path $full -PathType Leaf) { $state[$path] = (Get-Item $full).Length }
        else { $state[$path] = -1 }
    }
    return $state
}

function Compare-State($a, $b) {
    if ($null -eq $a -or $null -eq $b) { return $false }
    if ($a.Count -ne $b.Count) { return $false }
    foreach ($k in $a.Keys) {
        if (-not $b.ContainsKey($k)) { return $false }
        if ($a[$k] -ne $b[$k]) { return $false }
    }
    return $true
}

Write-Log "site watcher started (poll ${PollSeconds}s, settle ${SettleSeconds}s, builds from $BuildDir)"

while ($true) {
    try {
        $newApks = Sync-Apks
        if ($newApks.Count -gt 0) {
            Write-Log "new build detected: $($newApks -join ', ')"
            Update-Sizes
        }

        $first = Get-PendingState
        if ($null -eq $first) { Start-Sleep -Seconds $PollSeconds; continue }

        Write-Log "change: $($first.Keys -join ', ') - waiting for files to settle"
        Start-Sleep -Seconds $SettleSeconds
        $second = Get-PendingState
        if (-not (Compare-State $first $second)) {
            Write-Log "still being written - re-checking next poll"
            continue
        }

        $apks = @($second.Keys | Where-Object { $_ -like "*.apk" })
        if ($apks.Count -gt 0) { $subject = "Publish new build to inpani.pk" }
        else { $subject = "Update site: $(($second.Keys | Sort-Object) -join ', ')" }

        $detail = ($second.Keys | Sort-Object | ForEach-Object {
            if ($second[$_] -gt 0) { "  {0}  ({1:N1} MB)" -f $_, ($second[$_] / 1MB) } else { "  $_" }
        }) -join "`n"

        git add -A
        git commit -m "$subject" -m "Published automatically by watch-site.ps1.`n`n$detail"
        if ($LASTEXITCODE -ne 0) { Write-Log "nothing to commit"; continue }

        git push
        if ($LASTEXITCODE -ne 0) {
            Write-Log "push rejected - rebasing and retrying"
            git pull --rebase
            git push
            if ($LASTEXITCODE -ne 0) { Write-Log "ERROR: push still failing; commit kept locally"; continue }
        }
        Write-Log "pushed: $subject - Pages will redeploy in ~1 min"
    }
    catch {
        Write-Log "ERROR: $($_.Exception.Message)"
    }
    Start-Sleep -Seconds $PollSeconds
}
