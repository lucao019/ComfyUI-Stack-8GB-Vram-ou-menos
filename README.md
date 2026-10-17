# Video IA - MiniMax H3 no ComfyUI

Projeto de geração de vídeo realista com IA usando ComfyUI + MiniMax H3.

## Stack

- **ComfyUI Portable** (Windows + NVIDIA)
- **Modelo**: MiniMax H3 FL2VA W4A8 (otimizado para 6GB VRAM)
- **Text Encoder**: Qwen3-VL 4B + ClipProj adapter
- **VAE**: MiniMax H3 Video VAE INT8

## Hardware alvo

- GPU: RTX 2060 (6GB VRAM)
- RAM: 16GB
- OS: Windows

## Custom Nodes instalados

| Node | Função |
|---|---|
| [ComfyUI-KJNodes](https://github.com/kijai/ComfyUI-KJNodes) | Nodes utilitários |
| [ComfyUI-VideoHelperSuite](https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite) | Preview e exportação de vídeo |
| [comfyui-minimax-h3-audio-T8](https://github.com/T8mars/comfyui-minimax-h3-audio-T8) | Nodes principais do MiniMax H3 |
| [ComfyUI_Text_Translation](https://github.com/TFL-TFL/ComfyUI_Text_Translation) | Tradução de prompts |
| [Comfyui_Minimax_h3_latent_Upscaler](https://github.com/LBH-123-AI/Comfyui_Minimax_h3_latent_Upscaler) | Upscale de latentes |

## Modelos necessários

Baixar com o script `baixar_modelos_h3.py`:

```powershell
cd ComfyUI_windows_portable
.\python_embeded\python.exe ..\baixar_modelos_h3.py
```

| Arquivo | Repo HF | Pasta |
|---|---|---|
| `minimax_h3_fl2va_pruned_w4a8_mixed.safetensors` | starsfriday/MiniMax-H3-w4a8 | `models/diffusion_models/` |
| `qwen3vl_4b_int8_convrot.safetensors` | Stick9190/qwen3vl_4b_int8_convrot | `models/text_encoders/` |
| `mmh3-4b-ClipProj-v3-mlp.safetensors` | NicoLab28/ClipProj-MiniMax-H3 | `models/clip_projections/` |
| `minimax_h3_video_vae_int8_convrot.safetensors` | Kijai/MiniMax-H3-experimental | `models/vae/` |
| `minimax_h3_fl2v_turbo_4step_v1.0_768p_comfyui_bf16.safetensors` | Comfy-Org/MiniMax-H3 | `models/loras/` |

## Como rodar

1. Baixar os modelos com o script acima
2. Executar `ComfyUI_windows_portable\run_nvidia_gpu.bat`
3. Abrir `http://127.0.0.1:8188` no navegador
4. Carregar um workflow de `custom_nodes/comfyui-minimax-h3-audio-T8/examples/workflows/`
