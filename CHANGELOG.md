# Changelog

Todas as mudanças relevantes do projeto estão documentadas aqui.

---

## [Não lançado] — Em progresso

### Em andamento
- Download dos modelos MiniMax H3 (~21.5 GB via `baixar_modelos_h3.py`)

### Próximo
- Primeiro teste de geração de vídeo
- Ajuste de parâmetros para RTX 2060

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
