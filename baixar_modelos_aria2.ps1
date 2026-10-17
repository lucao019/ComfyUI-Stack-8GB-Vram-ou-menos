# Download MiniMax H3 - Stack para 6GB VRAM
# Usa aria2c: retoma automaticamente, 16 conexoes paralelas por arquivo
# Execute com: .\baixar_modelos_aria2.ps1

$BASE = "H:\video ia\ComfyUI_windows_portable\ComfyUI\models"

# Cria pasta clip_projections se nao existir
New-Item -ItemType Directory -Force -Path "$BASE\clip_projections" | Out-Null

# Caminho do aria2c
$aria2c = "C:\Users\tuuuu\AppData\Local\Microsoft\WinGet\Packages\aria2.aria2_Microsoft.Winget.Source_8wekyb3d8bbwe\aria2-1.37.0-win-64bit-build1\aria2c.exe"

# URL base do Hugging Face (download direto)
$HF = "https://huggingface.co"

$modelos = @(
    @{
        url     = "$HF/starsfriday/MiniMax-H3-w4a8/resolve/main/minimax_h3_fl2va_pruned_w4a8_mixed.safetensors"
        destino = "$BASE\diffusion_models"
        nome    = "minimax_h3_fl2va_pruned_w4a8_mixed.safetensors"
        tamanho = "~12.5 GB"
    },
    @{
        url     = "$HF/Stick9190/qwen3vl_4b_int8_convrot/resolve/main/qwen3vl_4b_int8_convrot.safetensors"
        destino = "$BASE\text_encoders"
        nome    = "qwen3vl_4b_int8_convrot.safetensors"
        tamanho = "~3 GB"
    },
    @{
        url     = "$HF/NicoLab28/ClipProj-MiniMax-H3/resolve/main/mmh3-4b-ClipProj-v3-mlp.safetensors"
        destino = "$BASE\clip_projections"
        nome    = "mmh3-4b-ClipProj-v3-mlp.safetensors"
        tamanho = "~50 MB"
    },
    @{
        url     = "$HF/Kijai/MiniMax-H3-experimental/resolve/main/minimax_h3_video_vae_int8_convrot.safetensors"
        destino = "$BASE\vae"
        nome    = "minimax_h3_video_vae_int8_convrot.safetensors"
        tamanho = "~5 GB"
    },
    @{
        url     = "$HF/Comfy-Org/MiniMax-H3/resolve/main/loras/minimax_h3_fl2v_turbo_4step_v1.0_768p_comfyui_bf16.safetensors"
        destino = "$BASE\loras"
        nome    = "minimax_h3_fl2v_turbo_4step_v1.0_768p_comfyui_bf16.safetensors"
        tamanho = "~1 GB"
    }
)

Write-Host "============================================================"
Write-Host " Download MiniMax H3 - Stack 6GB VRAM via aria2c"
Write-Host "============================================================"
Write-Host ""

foreach ($m in $modelos) {
    $arquivo = Join-Path $m.destino $m.nome

    if (Test-Path $arquivo) {
        $gb = [math]::Round((Get-Item $arquivo).Length / 1GB, 2)
        Write-Host "[JA EXISTE] $($m.nome) ($gb GB) - pulando"
        continue
    }

    Write-Host ""
    Write-Host "[BAIXANDO] $($m.nome) ($($m.tamanho))"
    Write-Host "  Destino: $($m.destino)"
    Write-Host ""

    & $aria2c `
        --dir="$($m.destino)" `
        --out="$($m.nome)" `
        --split=16 `
        --max-connection-per-server=16 `
        --min-split-size=50M `
        --continue=true `
        --retry-wait=5 `
        --max-tries=0 `
        --console-log-level=notice `
        "$($m.url)"

    if ($LASTEXITCODE -eq 0) {
        $gb = [math]::Round((Get-Item $arquivo).Length / 1GB, 2)
        Write-Host ""
        Write-Host "[OK] $($m.nome) - $gb GB"
    } else {
        Write-Host ""
        Write-Host "[ERRO] Falhou ao baixar $($m.nome) - rode o script novamente para retomar"
    }
}

Write-Host ""
Write-Host "============================================================"
Write-Host " Concluido! Modelos em: $BASE"
Write-Host "============================================================"
