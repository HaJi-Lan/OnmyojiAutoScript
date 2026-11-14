param([switch]$Apply)
$ErrorActionPreference = 'Stop'
$projectRoot = (Resolve-Path (Split-Path $PSScriptRoot -Parent)).Path
$source = Join-Path $projectRoot 'OAS'
$runtime = Join-Path $projectRoot 'runtime'
$destination = Join-Path $runtime 'upstream'
if (Test-Path $destination) { Write-Host '已使用统一运行目录。'; exit 0 }
if (-not (Test-Path (Join-Path $projectRoot 'OAS.exe'))) { throw '请先构建并验证 OAS.exe。' }
if (-not (Test-Path (Join-Path $source '.git'))) { throw '找不到上游 OAS 仓库。' }
foreach ($path in @($source, $destination)) {
    $resolved = [IO.Path]::GetFullPath($path)
    if (-not $resolved.StartsWith($projectRoot + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) {
        throw "目标超出项目目录：$resolved"
    }
}
$processes = Get-Process -ErrorAction SilentlyContinue | Where-Object {
    $_.Path -and ($_.Path.StartsWith($source + '\', [StringComparison]::OrdinalIgnoreCase) -or
    $_.Path -eq (Join-Path $projectRoot 'OAS.exe'))
}
if ($processes) { throw '请先关闭本目录运行的 OAS 和 Python 进程。' }
Write-Host "将移动 $source 到 $destination，保留完整 Git 历史、配置和日志。"
if (-not $Apply) { Write-Host '这是预览。使用 -Apply 执行。'; exit 0 }
New-Item -ItemType Directory -Force $runtime | Out-Null
Move-Item -LiteralPath $source -Destination $destination
$legacySource = [IO.Path]::GetFullPath((Join-Path $projectRoot 'OASX'))
$legacyDestination = [IO.Path]::GetFullPath((Join-Path $runtime 'legacy-oasx'))
foreach ($path in @($legacySource, $legacyDestination)) {
    if (-not $path.StartsWith($projectRoot + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase)) {
        throw "目标超出项目目录：$path"
    }
}
if ((Test-Path -LiteralPath $legacySource) -and -not (Test-Path -LiteralPath $legacyDestination)) {
    Move-Item -LiteralPath $legacySource -Destination $legacyDestination
}
Write-Host '已整合。原 OASX 保留在 runtime/legacy-oasx，新的 OAS.exe 不依赖它。'
