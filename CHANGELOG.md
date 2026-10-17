# Changelog

Todas as mudanças relevantes do projeto estão documentadas aqui.

---

## [Não lançado] — Em progresso

### Próximo
- Workflow I2VA (Image to Video) com foto do rosto
- Geração de vídeo com expressão facial — feliz para triste
- Ajuste de performance para gerações mais longas (90 frames, 30fps)

---

## [0.2.0] — 2026-10-17

### Primeiro vídeo gerado com sucesso

#### Adicionado
- **`ComfyUI-ClipProj`** — custom node instalado para fazer a ponte entre
  Qwen 4B (dim 2560) e o H3 (dim 5120), resolvendo o erro de shape mismatch
- **`baixar_modelos_aria2.ps1`** — script de download via aria2c com 16 conexões
  paralelas, retomada automática e muito mais estável que o `hf_hub_download`
- **`workflow_minimax_h3_meus_modelos.json`** — workflow T2VA completo e funcional
  com todos os modelos do stack 6GB VRAM:
  - `UNETLoader` → W4A8 pruned
  - `CLIPLoader` → Qwen 4B INT8
  - `ClipProjApply` → matriz mmh3-4b-ClipProj-v3-mlp
  - `VAELoader` x2 → vídeo INT8 + áudio FP32
  - `LoraLoaderBypassModelOnly` → Turbo 4-step
  - `MiniMaxH3AudioConditioningT8` → conditioning T2VA
  - `MiniMaxH3DualClockSamplerT8` → sampler dual clock
  - `MiniMaxH3AVDecodeT8` → decode vídeo+áudio
  - `VHS_VideoCombine` → exporta MP4 H.264

#### Corrigido
- Erro `mat1 and mat2 shapes cannot be multiplied (37x2560 and 5120x5376)` —
  causado pela ausência do nó `ClipProjApply` entre o CLIP e o conditioning
- Erro de download travando em 33-47% — substituído `hf_hub_download` por `aria2c`
- Arquivo `.aria2` de controle órfão removido da pasta `vae/`
- `aria2c` não reconhecido no PATH — usando caminho absoluto do executável
- Workflow original do custom node usava modelos incompatíveis com o stack 6GB
  (`int8_convrot`, `nvfp4_awq`, `vae_fp16`) — todos substituídos pelos corretos

#### Primeiro resultado
- Vídeo T2VA gerado com sucesso: chuva em telhado de metal à noite
- Resolução: 512x320 — Frames: 49 — FPS: 24 — Duração: ~2s
- Tempo de geração: ~45 minutos (RTX 2060, CPU offload, 4 passos Turbo)
- Vídeo com áudio gerado nativamente e sincronizado

#### Performance observada (RTX 2060 6GB + 16GB RAM)
- ~10-12 minutos por passo de sampling
- Total 4 passos: ~45 minutos para 2s de vídeo
- Modelo opera em modo CPU offload (11GB não cabe nos 6GB de VRAM)
- Resoluções menores (384x224) podem reduzir para ~10 min por geração

---

## [0.1.0] — 2026-10-16

### Setup inicial completo

#### Adicionado
- **ComfyUI Windows Portable** extraído em `H:\video ia\ComfyUI_windows_portable\`
- **5 custom nodes** instalados em `ComfyUI\custom_nodes\`:
  - `ComfyUI-KJNodes` — nodes utilitários
  - `ComfyUI-VideoHelperSuite` — preview e exportação de vídeo
  - `comfyui-minimax-h3-audio-T8` — nodes do MiniMax H3 com suporte a áudio
  - `ComfyUI_Text_Translation` — tradução de prompts
  - `Comfyui_Minimax_h3_latent_Upscaler` — upscale de latentes
- **Dependências Python** instaladas via `python_embeded`:
  - `color-matcher`, `matplotlib`, `mss`, `opencv-python-headless` (KJNodes)
  - `opencv-python`, `imageio-ffmpeg` (VideoHelperSuite)
  - Todas as dependências do `comfyui-minimax-h3-audio-T8`
- **`baixar_modelos_h3.py`** — script automatizado de download dos modelos
  - Stack otimizado para 6GB VRAM + 16GB RAM
  - W4A8 diffusion model (~12.5 GB)
  - Qwen 4B text encoder + ClipProj adapter (substitui o 32B de 15.7 GB)
  - Video VAE INT8
  - Turbo LoRA 4-step
  - Retoma download automaticamente se cair a conexão
- **`README.md`** — documentação completa com passo a passo
- **`CHANGELOG.md`** — este arquivo
- **`.gitignore`** configurado para excluir:
  - Modelos grandes (`.safetensors`, `.gguf`, `.bin`, `.pt`, `.ckpt`)
  - `python_embeded/` (~2 GB)
  - `ComfyUI/` core (tem repo próprio)
  - `output/` e `input/`
  - Arquivos compactados (`.7z`, `.zip`)
- **Repositório git** inicializado com primeiro commit

#### Corrigido
- Custom nodes clonados por engano em `H:\video ia\` foram movidos para
  `ComfyUI\custom_nodes\` usando `robocopy` (o `Move-Item` do PowerShell
  bloqueava as pastas `.git`)

#### Decisões técnicas
- Escolhido stack **W4A8 + Qwen 4B + ClipProj** em vez do stack oficial 32B
  para viabilizar execução em RTX 2060 (6 GB VRAM) com 16 GB de RAM
- `python_embeded` e `ComfyUI` core excluídos do git — ambos têm repositórios
  próprios e são grandes demais para versionar aqui
- Custom nodes documentados no README com links para instalação via `git clone`
