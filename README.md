# dotfiles

Configs pessoais de desenvolvimento baseadas em symlinks e um script shell.

Funciona em dois contextos:
- **WSL2 / máquina física** — instala ferramentas e aplica configs
- **Devcontainer** — só aplica configs (ferramentas já estão na [imagem base](https://github.com/evanbs/devbase))

## Instalação

```bash
git clone https://github.com/evanbs/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
exec zsh -l
```

## O que instala (WSL2 / máquina física)

| Ferramenta | Descrição |
|---|---|
| zsh + oh-my-zsh | Shell |
| starship | Prompt Catppuccin Frappe |
| fnm | Node version manager |
| eza | `ls` moderno |
| bat | `cat` com syntax highlight |
| git-delta | Diff colorido |
| ripgrep | Busca ultrarrápida |
| fzf | Fuzzy finder |
| jq | Processador de JSON |

## O que aplica (qualquer contexto)

| Arquivo | Destino |
|---|---|
| `starship/starship.toml` | `~/.config/starship.toml` |
| `git/.gitconfig` | `~/.gitconfig` |
| `aliases/.aliases.local` | `~/.aliases.local` |
| `zsh/.zshrc.local` | `~/.zshrc.local` |

## Uso com devcontainer

Configurar no VS Code (uma vez por máquina):

**Settings → buscar "dotfiles":**

```json
{
  "dotfiles.repository": "evanbs/dotfiles",
  "dotfiles.targetPath": "~/dotfiles",
  "dotfiles.installCommand": "install.sh"
}
```

A partir daí, qualquer container que você abrir vai ter
automaticamente seu starship, gitconfig e aliases pessoais.

## Estrutura

```
dotfiles/
├── install.sh
├── zsh/
│   └── .zshrc.local
├── starship/
│   └── starship.toml
├── git/
│   └── .gitconfig
└── aliases/
    └── .aliases.local
```
