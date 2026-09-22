[CmdletBinding()]
param(
    [string]$Repo = '.',
    [string]$Package,
    [string]$ExpectedName,
    [string]$ExpectedPublisher,
    [string[]]$ForbiddenString = @(
        'updates/latest.json',
        'app-frontend/latest.json'
    )
)

$ErrorActionPreference = 'Stop'
$repoPath = (Resolve-Path -LiteralPath $Repo).Path
Write-Host "Repository: $repoPath"

$manifestCandidates = Get-ChildItem -LiteralPath $repoPath -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object {
        $_.Name -in @('AppxManifest.xml', 'Package.appxmanifest') -or
        $_.Name -match 'tauri.*\.conf\.json$'
    } |
    Where-Object { $_.FullName -notmatch '[\\/](node_modules|target|dist|build|\.git)[\\/]' }

Write-Host 'Store configuration candidates:'
$manifestCandidates | ForEach-Object { Write-Host "  $($_.FullName.Substring($repoPath.Length).TrimStart('\'))" }

$sourcePatterns = @(
    'updater',
    'download app',
    '下载 App',
    'latest.json',
    'msstore',
    'microsoft store',
    'runFullTrust'
)

Write-Host 'Relevant source markers:'
$sourceFiles = Get-ChildItem -LiteralPath $repoPath -Recurse -File -ErrorAction SilentlyContinue |
    Where-Object { $_.FullName -notmatch '[\\/](node_modules|target|dist|build|\.git)[\\/]' } |
    Where-Object { $_.Length -le 5MB }
foreach ($pattern in $sourcePatterns) {
    $hits = $sourceFiles | Select-String -Pattern $pattern -List -ErrorAction SilentlyContinue | Select-Object -First 20
    foreach ($hit in $hits) {
        $relative = $hit.Path.Substring($repoPath.Length).TrimStart('\')
        Write-Host "  [$pattern] ${relative}:$($hit.LineNumber)"
    }
}

if ($Package) {
    $verifyScript = Join-Path $PSScriptRoot 'verify-msix.ps1'
    & $verifyScript -Package $Package -ExpectedName $ExpectedName -ExpectedPublisher $ExpectedPublisher -ForbiddenString $ForbiddenString
}
else {
    Write-Warning 'No package supplied. Source discovery completed, but final MSIX contents were not verified.'
}
