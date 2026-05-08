# dotfiles — instruções para Claude Code

## Contexto

Dotfiles pessoais baseados em symlinks e um script shell.
Funciona em dois contextos detectados automaticamente pelo `install.sh`:
- **WSL2 / máquina física** — instala ferramentas e aplica configs
- **Devcontainer** — só aplica configs (ferramentas já estão na imagem base)

## Estrutura

```
dotfiles/
├── install.sh               # entry point — detecta contexto e executa
├── zsh/
│   └── .zshrc.local         # carregado pelo hook da imagem base
├── starship/
│   └── starship.toml        # tema Catppuccin Frappe
├── git/
│   └── .gitconfig           # nome, email, delta
└── aliases/
    └── .aliases.local       # aliases pessoais extras
```

## Como funciona

```
devbase (imagem base)
    └── .zshrc.append carrega ~/.zshrc.local (se existir)

dotfiles/install.sh
    └── cria symlinks:
          ~/.config/starship.toml → dotfiles/starship/starship.toml
          ~/.gitconfig            → dotfiles/git/.gitconfig
          ~/.aliases.local        → dotfiles/aliases/.aliases.local
          ~/.zshrc.local          → dotfiles/zsh/.zshrc.local
```

## Tarefas comuns

### Aplicar dotfiles no WSL2 (primeira vez)

```bash
git clone https://github.com/evanbs/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
exec zsh -l
```

### Aplicar dotfiles no WSL2 (atualizar)

```bash
cd ~/dotfiles
git pull
./install.sh
exec zsh -l
```

### Testar no devcontainer

O VS Code injeta automaticamente via `dotfiles.repository`.
Para testar manualmente dentro de um container:

```bash
git clone https://github.com/evanbs/dev-dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

### Adicionar alias pessoal

Editar `aliases/.aliases.local` e recarregar:

```bash
source ~/.aliases.local
```

### Atualizar configuração do starship

Editar `starship/starship.toml` — o symlink reflete imediatamente,
não precisa recarregar o shell.

### Atualizar gitconfig

Editar `git/.gitconfig` — o symlink reflete imediatamente.

## Configuração do VS Code (uma vez por máquina)

Configurar nas settings do VS Code para injetar automaticamente
em qualquer devcontainer:

```json
{
  "dotfiles.repository": "evanbs/dev-dotfiles",
  "dotfiles.targetPath": "~/dotfiles",
  "dotfiles.installCommand": "install.sh"
}
```

## Variáveis de ambiente sensíveis

Nunca versionar no repositório. Adicionar diretamente no WSL2:

```bash
# ~/.zshrc do WSL2 (fora do dotfiles)
export ANTHROPIC_API_KEY="sk-ant-..."
export GH_TOKEN="ghp_..."
```

O `.zshrc.local` tem um bloco comentado como lembrete — não descomentar.

## Regras

- Nunca adicionar dados sensíveis (tokens, senhas, chaves)
- Nunca adicionar configs de ferramentas que estão na imagem base (eza, bat, rg)
- Aliases de WSL (`explorer.exe`, `wsl.exe`) só carregam se detectar WSL2
- O `install.sh` deve ser idempotente — pode rodar múltiplas vezes sem quebrar

## Troubleshooting

**Starship não aparece no container:**
```bash
# Verificar se o symlink foi criado
ls -la ~/.config/starship.toml

# Verificar se starship está instalado
which starship

# Recriar o symlink manualmente
ln -sf ~/dotfiles/starship/starship.toml ~/.config/starship.toml
```

**Aliases pessoais não carregam:**
```bash
# Verificar se .zshrc.local está sendo carregado
cat ~/.zshrc | grep zshrc.local

# Verificar se o symlink existe
ls -la ~/.zshrc.local

# Carregar manualmente
source ~/.zshrc.local
```

**Git não usa delta:**
```bash
# Verificar se delta está instalado
which delta

# Verificar se .gitconfig está com symlink correto
ls -la ~/.gitconfig
git config --list | grep pager
```

**install.sh falhou no meio:**
O script usa `set -euo pipefail` — para na primeira falha.
Verificar o erro, corrigir e rodar novamente. É idempotente.
