"""
Script de download dos modelos MiniMax H3 para ComfyUI
Otimizado para RTX 2060 (6GB VRAM) + 16GB RAM
Stack: W4A8 + Qwen 4B + ClipProj + VAE de video
Total estimado: ~20GB de download
"""

from huggingface_hub import hf_hub_download
import os

BASE = r"H:\video ia\ComfyUI_windows_portable\ComfyUI\models"

# Cria pasta clip_projections se nao existir
os.makedirs(os.path.join(BASE, "clip_projections"), exist_ok=True)

modelos = [
    # (repo_id, arquivo_no_repo, pasta_local)

    # Modelo principal - W4A8 ~12.5GB, menor e roda em 6GB com offload
    (
        "starsfriday/MiniMax-H3-w4a8",
        "minimax_h3_fl2va_pruned_w4a8_mixed.safetensors",
        "diffusion_models",
    ),

    # Text encoder Qwen 4B (muito menor que 32B, ~3GB)
    (
        "Stick9190/qwen3vl_4b_int8_convrot",
        "qwen3vl_4b_int8_convrot.safetensors",
        "text_encoders",
    ),

    # Matriz de projecao ClipProj 4B (permite usar o encoder 4B no lugar do 32B)
    (
        "NicoLab28/ClipProj-MiniMax-H3",
        "mmh3-4b-ClipProj-v3-mlp.safetensors",
        "clip_projections",
    ),

    # VAE de video
    (
        "Kijai/MiniMax-H3-experimental",
        "minimax_h3_video_vae_int8_convrot.safetensors",
        "vae",
    ),

    # Turbo LoRA 4-step (necessario para geracao rapida)
    (
        "Comfy-Org/MiniMax-H3",
        "loras/minimax_h3_fl2v_turbo_4step_v1.0_768p_comfyui_bf16.safetensors",
        "loras",
    ),
]

print("=" * 60)
print("Download MiniMax H3 - Stack para 6GB VRAM / 16GB RAM")
print("=" * 60)
print()

total_baixado = 0

for repo_id, filename, pasta in modelos:
    destino = os.path.join(BASE, pasta)
    nome_arquivo = os.path.basename(filename)
    caminho_final = os.path.join(destino, nome_arquivo)

    if os.path.exists(caminho_final):
        tamanho = os.path.getsize(caminho_final) / (1024**3)
        print(f"[JA EXISTE] {nome_arquivo} ({tamanho:.2f} GB) - pulando")
        total_baixado += tamanho
        continue

    print(f"\n[BAIXANDO] {nome_arquivo}")
    print(f"  Repo   : {repo_id}")
    print(f"  Destino: {destino}")

    try:
        hf_hub_download(
            repo_id=repo_id,
            filename=filename if "/" not in filename else os.path.basename(filename),
            local_dir=destino,
            local_dir_use_symlinks=False,
        )
        tamanho = os.path.getsize(caminho_final) / (1024**3)
        total_baixado += tamanho
        print(f"  [OK] {tamanho:.2f} GB baixados")
    except Exception as e:
        print(f"  [ERRO] {e}")

print()
print("=" * 60)
print(f"Concluido! Total em disco: {total_baixado:.2f} GB")
print("=" * 60)
print()
print("Proximos passos:")
print("1. Abra o ComfyUI: run_nvidia_gpu.bat")
print("2. Carregue o workflow de exemplo do custom node")
