param(
    [Parameter(Mandatory = $false)]
    [string] $PackageRoot = ".",

    [Parameter(Mandatory = $true)]
    [string] $ExpectedName
)

$ErrorActionPreference = "Stop"
$root = (Resolve-Path -LiteralPath $PackageRoot).Path
$manifestPath = Join-Path $root "package.json"

if (-not (Test-Path -LiteralPath $manifestPath -PathType Leaf)) {
    throw "Missing package.json at $manifestPath"
}

$manifest = Get-Content -LiteralPath $manifestPath -Raw | ConvertFrom-Json
if ($manifest.name -ne $ExpectedName) {
    throw "Package name '$($manifest.name)' does not match expected name '$ExpectedName'."
}

foreach ($property in @("name", "displayName", "version", "unity", "description", "author")) {
    if ($null -eq $manifest.$property -or [string]::IsNullOrWhiteSpace([string] $manifest.$property)) {
        throw "package.json is missing required property '$property'."
    }
}

if ([string] $manifest.version -notmatch '^(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)(?:-[0-9A-Za-z.-]+)?(?:\+[0-9A-Za-z.-]+)?$') {
    throw "Package version '$($manifest.version)' is not valid Semantic Versioning."
}

if ($ExpectedName -eq "com.wolfyvr.threadlight.mirroring") {
    $coreDependency = $manifest.vpmDependencies.PSObject.Properties[
        "com.wolfyvr.threadlight.authoring"
    ]
    if ($null -eq $coreDependency -or
        $coreDependency.Value -ne ">=1.0.0 <2.0.0") {
        throw "Threadlight Mirroring must depend on Threadlight Authoring 1.x."
    }
    $componentsDependency = $manifest.vpmDependencies.PSObject.Properties[
        "com.wolfyvr.threadlight.components"
    ]
    if ($null -ne $componentsDependency) {
        throw "Threadlight Mirroring must not depend on the customer-only Threadlight Components package."
    }
}

$contentFiles = Get-ChildItem -LiteralPath $root -Recurse -File -Force | Where-Object {
    $_.Extension -ne ".meta" -and
    $_.FullName -notmatch '[\\/]\.git[\\/]' -and
    $_.FullName -notmatch '[\\/]\.github[\\/]' -and
    $_.FullName -notmatch '[\\/]\.vpm-listing[\\/]' -and
    $_.Name -notin @(".gitignore", ".gitattributes", ".editorconfig")
}

foreach ($file in $contentFiles) {
    if (-not (Test-Path -LiteralPath "$($file.FullName).meta" -PathType Leaf)) {
        throw "Unity metadata is missing for '$($file.FullName.Substring($root.Length + 1))'."
    }
}

$metaFiles = Get-ChildItem -LiteralPath $root -Recurse -File -Filter "*.meta" -Force | Where-Object {
    $_.FullName -notmatch '[\\/]\.git[\\/]' -and
    $_.FullName -notmatch '[\\/]\.github[\\/]' -and
    $_.FullName -notmatch '[\\/]\.vpm-listing[\\/]'
}

$guids = @{}
foreach ($metaFile in $metaFiles) {
    $assetPath = $metaFile.FullName.Substring(0, $metaFile.FullName.Length - 5)
    $relative = $metaFile.FullName.Substring($root.Length + 1)
    if (-not (Test-Path -LiteralPath $assetPath)) {
        throw "Orphaned Unity metadata '$relative'."
    }

    $guidLine = Select-String `
        -LiteralPath $metaFile.FullName `
        -Pattern '^guid:\s*([0-9a-fA-F]{32})\s*$' |
        Select-Object -First 1
    if ($null -eq $guidLine) {
        throw "Unity metadata '$relative' does not contain a valid GUID."
    }

    $guid = $guidLine.Matches[0].Groups[1].Value.ToLowerInvariant()
    if ($guids.ContainsKey($guid)) {
        $first = $guids[$guid].Substring($root.Length + 1)
        throw "Duplicate Unity GUID '$guid' in '$first' and '$relative'."
    }
    $guids[$guid] = $metaFile.FullName
}

Write-Host "Validated $($manifest.displayName) $($manifest.version): $($contentFiles.Count) assets and $($metaFiles.Count) metadata files."
