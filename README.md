# ComfyUI Stack — MiniMax H3 para 8GB de VRAM ou menos

Guia completo e scripts para rodar geração de **vídeo realista com IA** no ComfyUI usando o modelo **MiniMax H3**, otimizado para GPUs com 6–8GB de VRAM e 16GB de RAM.

---

## Hardware testado

| Componente | Especificação |
|---|---|
| GPU | NVIDIA RTX 2060 (6GB VRAM) |
| RAM | 16GB |
| OS | Windows 11 |
| Disco | HD/SSD externo (H:\) |

---

## Stack de modelos

Versões escolhidas para caber em 6GB VRAM com offload para RAM:

| Arquivo | Repositório HF | Pasta no ComfyUI | Tamanho |
|---|---|---|---|
| `minimax_h3_fl2va_pruned_w4a8_mixed.safetensors` | [starsfriday/MiniMax-H3-w4a8](https://huggingface.co/starsfriday/MiniMax-H3-w4a8) | `models/diffusion_models/` | ~12.5 GB |
| `qwen3vl_4b_int8_convrot.safetensors` | [Stick9190/qwen3vl_4b_int8_convrot](https://huggingface.co/Stick9190/qwen3vl_4b_int8_convrot) | `models/text_encoders/` | ~3 GB |
| `mmh3-4b-ClipProj-v3-mlp.safetensors` | [NicoLab28/ClipProj-MiniMax-H3](https://huggingface.co/NicoLab28/ClipProj-MiniMax-H3) | `models/clip_projections/` | ~50 MB |
| `minimax_h3_video_vae_int8_convrot.safetensors` | [Kijai/MiniMax-H3-experimental](https://huggingface.co/Kijai/MiniMax-H3-experimental) | `models/vae/` | ~5 GB |
| `minimax_h3_fl2v_turbo_4step_v1.0_768p_comfyui_bf16.safetensors` | [Comfy-Org/MiniMax-H3](https://huggingface.co/Comfy-Org/MiniMax-H3) | `models/loras/` | ~1 GB |

**Total: ~21.5 GB de download**

> O text encoder Qwen 4B + ClipProj substitui o Qwen 32B oficial (15.7 GB), tornando o stack viável em 16GB de RAM.

---

## Pré-requisitos

- [Driver NVIDIA atualizado](https://www.nvidia.com/drivers)
- [Visual C++ Redistributable](https://aka.ms/vc14/vc_redist.x64.exe)
- [Git para Windows](https://git-scm.com/download/win)
- ComfyUI Windows Portable (NVIDIA) — veja instalação abaixo

---

## Instalação passo a passo

### 1. ComfyUI Portable

Baixe o `ComfyUI_windows_portable_nvidia.7z` em [github.com/comfyanonymous/ComfyUI/releases](https://github.com/comfyanonymous/ComfyUI/releases) e extraia em uma pasta com espaço suficiente (mínimo 60GB livres).

### 2. Clone este repositório

```powershell
git clone https://github.com/lucao019/ComfyUI-Stack-8GB-Vram-ou-menos.git "H:\video ia"
```

Ou copie apenas os arquivos `baixar_modelos_h3.py` e `.gitignore` para a raiz do seu projeto.

### 3. Instalar os custom nodes

Abra um terminal na pasta `ComfyUI\custom_nodes` e rode:

```powershell
git clone https://github.com/kijai/ComfyUI-KJNodes
git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite
git clone https://github.com/T8mars/comfyui-minimax-h3-audio-T8
git clone https://github.com/TFL-TFL/ComfyUI_Text_Translation
git clone https://github.com/LBH-123-AI/Comfyui_Minimax_h3_latent_Upscaler
```

### 4. Instalar dependências Python

```powershell
cd ComfyUI_windows_portable

.\python_embeded\python.exe -m pip install -r ComfyUI\custom_nodes\comfyui-minimax-h3-audio-T8\requirements.txt
.\python_embeded\python.exe -m pip install -r ComfyUI\custom_nodes\ComfyUI-KJNodes\requirements.txt
.\python_embeded\python.exe -m pip install -r ComfyUI\custom_nodes\ComfyUI-VideoHelperSuite\requirements.txt
```

### 5. Baixar os modelos

```powershell
cd ComfyUI_windows_portable
.\python_embeded\python.exe ..\baixar_modelos_h3.py
```

O script baixa todos os 5 arquivos nas pastas corretas automaticamente. Retoma se a conexão cair.

### 6. Rodar o ComfyUI

```powershell
ComfyUI_windows_portable\run_nvidia_gpu.bat
```

Acesse `http://127.0.0.1:8188` no navegador.

### 7. Carregar um workflow

Os workflows de exemplo estão em:
```
ComfyUI\custom_nodes\comfyui-minimax-h3-audio-T8\examples\workflows\
```

Para começar use: `01-basic-generation\2026-08-06_H3_Turbo_Stable_4V4A.json`

---

## Custom nodes instalados

| Node | Função |
|---|---|
| [ComfyUI-KJNodes](https://github.com/kijai/ComfyUI-KJNodes) | Nodes utilitários essenciais |
| [ComfyUI-VideoHelperSuite](https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite) | Preview e exportação de vídeo |
| [comfyui-minimax-h3-audio-T8](https://github.com/T8mars/comfyui-minimax-h3-audio-T8) | Nodes principais do MiniMax H3 com áudio |
| [ComfyUI_Text_Translation](https://github.com/TFL-TFL/ComfyUI_Text_Translation) | Tradução de prompts para inglês |
| [Comfyui_Minimax_h3_latent_Upscaler](https://github.com/LBH-123-AI/Comfyui_Minimax_h3_latent_Upscaler) | Upscale de latentes H3 |

---

## Status atual

- [x] ComfyUI Portable extraído e funcionando
- [x] 5 custom nodes instalados nas pastas corretas
- [x] `ComfyUI-ClipProj` instalado (bridge Qwen 4B → H3)
- [x] Dependências Python instaladas
- [x] Modelos baixados (~22 GB via aria2c)
- [x] Workflow T2VA funcional (`workflow_minimax_h3_meus_modelos.json`)
- [x] **Primeiro vídeo gerado com sucesso** 🎉
- [ ] Workflow I2VA com imagem do rosto (próximo passo)

---

## Notas de performance (RTX 2060 6GB)

- O modelo roda com **CPU offload** — parte do processamento vai para a RAM
- Tempo estimado por vídeo de ~5s: **10–20 minutos**
- Resolução recomendada para começar: **512x320** ou **640x384**
- Turbo LoRA de 4 passos reduz tempo pela metade

---

## Referências

- [MiniMax H3 oficial](https://huggingface.co/MiniMaxAI/MiniMax-H3)
- [Comfy-Org/MiniMax-H3](https://huggingface.co/Comfy-Org/MiniMax-H3) — repack oficial para ComfyUI
- [ComfyUI Docs — MiniMax H3](https://docs.comfy.org/tutorials/video/minimax/minimax-h3)
- [reventadirecta/MiniMax-H3-ComfyUI-8GB-VRAM](https://github.com/reventadirecta/MiniMax-H3-ComfyUI-8GB-VRAM) — referência de stack low VRAM
