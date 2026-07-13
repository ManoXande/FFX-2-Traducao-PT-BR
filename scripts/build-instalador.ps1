#Requires -Version 5.1

$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path

$iscc = $null

$candidates = @(
    "${env:ProgramFiles(x86)}\Inno Setup 6\ISCC.exe",
    "$env:ProgramFiles\Inno Setup 6\ISCC.exe",
    "$env:LOCALAPPDATA\Programs\Inno Setup 6\ISCC.exe"
)

foreach ($path in $candidates) {
    if (Test-Path -LiteralPath $path) {
        $iscc = $path
        break
    }
}

if (-not $iscc) {
    $cmd = Get-Command ISCC.exe -ErrorAction SilentlyContinue
    if ($cmd) {
        $iscc = $cmd.Source
    }
}

if (-not $iscc) {
    Write-Host ''
    Write-Host 'ERRO: Inno Setup 6 nao foi encontrado neste computador.' -ForegroundColor Red
    Write-Host ''
    Write-Host 'Para compilar o instalador, e necessario instalar o Inno Setup 6.'
    Write-Host 'O compilador ISCC.exe nao foi localizado nos caminhos padrao nem no PATH.'
    Write-Host ''
    Write-Host 'Baixe e instale a partir do site oficial:'
    Write-Host '  https://jrsoftware.org/isdl.php'
    Write-Host ''
    exit 1
}

$outDir = Join-Path $repoRoot 'instalador\saida'

Push-Location $repoRoot
try {
    & $iscc 'instalador\instalador.iss'
    if ($LASTEXITCODE -ne 0) {
        Write-Host ''
        Write-Host "ERRO: A compilacao do instalador falhou (codigo de saida: $LASTEXITCODE)." -ForegroundColor Red
        Write-Host ''
        exit $LASTEXITCODE
    }
}
finally {
    Pop-Location
}

Write-Host ''
Write-Host 'Instalador compilado com sucesso.' -ForegroundColor Green
Write-Host "Saida: $outDir"
Write-Host ''

$exes = Get-ChildItem -Path $outDir -Filter '*.exe' -ErrorAction SilentlyContinue
if ($exes) {
    Write-Host 'Executaveis gerados:'
    foreach ($exe in $exes) {
        Write-Host "  $($exe.FullName)"
    }
} else {
    Write-Host "Nenhum arquivo .exe encontrado em $outDir" -ForegroundColor Yellow
}

Write-Host ''
