# ============================================================================
# 修复BOM.ps1 —— 为 mod 目录下所有 .yml / .txt 补回 UTF-8 BOM
# ----------------------------------------------------------------------------
# 为什么需要：
# · EU5 硬性要求：yml 必须 UTF-8 BOM，否则整个文件被游戏忽略（官方 wiki）。
# · common 的 txt 原版也全部带 BOM；无 BOM 会刷
#   "should be in utf8-bom encoding (will try to use it anyways)" 警告，
#   含中文注释的文件有解析失败风险。
# · 已知坑：编辑工具（edit）每次写文件都会抹掉 BOM——所以每次编辑完
#   跑一次本脚本，全目录一键补回。
# ----------------------------------------------------------------------------
# 用法（在 mod 根目录）：
#   powershell -ExecutionPolicy Bypass -File 修复BOM.ps1
# 或直接在 PowerShell 里：
#   & .\修复BOM.ps1
# 脚本自动扫描自身所在目录（mod 根）下所有子目录的 yml/txt。
# ============================================================================

$root = Split-Path -Parent $MyInvocation.MyCommand.Path

$extensions = @('*.yml', '*.txt')
$fixed = 0
$total = 0

Get-ChildItem -Path $root -Recurse -File -Include $extensions | ForEach-Object {
	$total++
	$bytes = [System.IO.File]::ReadAllBytes($_.FullName)
	$hasBom = $bytes.Length -ge 3 -and $bytes[0] -eq 0xEF -and $bytes[1] -eq 0xBB -and $bytes[2] -eq 0xBF
	if (-not $hasBom) {
		[System.IO.File]::WriteAllBytes($_.FullName, ([byte[]](0xEF, 0xBB, 0xBF)) + $bytes)
		$fixed++
		Write-Host ("补回 BOM: " + $_.FullName.Substring($root.Length + 1))
	}
}

Write-Host ("完成：共 {0} 个 yml/txt 文件，补回 BOM {1} 个。" -f $total, $fixed)
