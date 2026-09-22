[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$Package,
    [string]$ExpectedName,
    [string]$ExpectedPublisher,
    [string]$ExpectedVersion,
    [string[]]$ForbiddenString = @()
)

$ErrorActionPreference = 'Stop'
$packagePath = (Resolve-Path -LiteralPath $Package).Path
$workRoot = Join-Path ([System.IO.Path]::GetTempPath()) ("app-store-release-msix-" + [guid]::NewGuid().ToString('N'))
$unpackPath = Join-Path $workRoot 'unpacked'
New-Item -ItemType Directory -Path $unpackPath -Force | Out-Null

function Fail([string]$Message) {
    throw "MSIX verification failed: $Message"
}

try {
    $makeAppx = Get-Command makeappx.exe -ErrorAction SilentlyContinue
    if (-not $makeAppx) {
        Fail 'makeappx.exe was not found. Install the Windows SDK and run this script on Windows.'
    }

    & $makeAppx.Source unpack /p $packagePath /d $unpackPath /o | Out-Host
    if ($LASTEXITCODE -ne 0) { Fail "makeappx unpack exited with $LASTEXITCODE" }

    $manifestPath = Join-Path $unpackPath 'AppxManifest.xml'
    if (-not (Test-Path -LiteralPath $manifestPath)) { Fail 'AppxManifest.xml is missing' }

    [xml]$manifest = Get-Content -LiteralPath $manifestPath -Raw
    $identity = $manifest.Package.Identity
    if (-not $identity) { Fail 'manifest Identity is missing' }

    $actualName = [string]$identity.Name
    $actualPublisher = [string]$identity.Publisher
    $actualVersion = [string]$identity.Version
    $actualArchitecture = [string]$identity.ProcessorArchitecture

    if ($ExpectedName -and $actualName -ne $ExpectedName) { Fail "identity name '$actualName' does not match '$ExpectedName'" }
    if ($ExpectedPublisher -and $actualPublisher -ne $ExpectedPublisher) { Fail "publisher '$actualPublisher' does not match '$ExpectedPublisher'" }
    if ($ExpectedVersion -and $actualVersion -ne $ExpectedVersion) { Fail "version '$actualVersion' does not match '$ExpectedVersion'" }
    if ($actualVersion -notmatch '^\d+\.\d+\.\d+\.\d+$') { Fail "version '$actualVersion' is not four-part numeric" }

    $hash = (Get-FileHash -LiteralPath $packagePath -Algorithm SHA256).Hash.ToLowerInvariant()
    $minVersions = @($manifest.Package.Dependencies.TargetDeviceFamily | ForEach-Object { [string]$_.MinVersion } | Where-Object { $_ })
    $capabilities = @($manifest.Package.Capabilities.ChildNodes | ForEach-Object { $_.Name } | Where-Object { $_ })

    foreach ($needle in $ForbiddenString) {
        if ([string]::IsNullOrWhiteSpace($needle)) { continue }
        $matches = Get-ChildItem -LiteralPath $unpackPath -Recurse -File | Select-String -SimpleMatch -Pattern $needle -List -ErrorAction SilentlyContinue
        if ($matches) {
            $relative = $matches | ForEach-Object { $_.Path.Substring($unpackPath.Length).TrimStart('\') } | Sort-Object -Unique
            Fail "forbidden string '$needle' found in: $($relative -join ', ')"
        }
    }

    [pscustomobject]@{
        Package = $packagePath
        Sha256 = $hash
        IdentityName = $actualName
        Publisher = $actualPublisher
        Version = $actualVersion
        Architecture = $actualArchitecture
        MinWindowsVersions = $minVersions -join ', '
        Capabilities = $capabilities -join ', '
        FileCount = @(Get-ChildItem -LiteralPath $unpackPath -Recurse -File).Count
    } | Format-List

    Write-Host 'MSIX verification passed.' -ForegroundColor Green
}
finally {
    if (Test-Path -LiteralPath $workRoot) {
        Remove-Item -LiteralPath $workRoot -Recurse -Force
    }
}
