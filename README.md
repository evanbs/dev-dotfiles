# dotfiles

Configs pessoais de desenvolvimento baseadas em symlinks e um script shell.
Funciona como **template** — cada dev cria o próprio fork e personaliza.

Funciona em dois contextos:
- **WSL2 / máquina física** — instala ferramentas e aplica configs
- **Devcontainer** — só aplica configs (ferramentas já estão na [imagem base](https://github.com/evanbs/devbase))

## Novo no time? Comece aqui

1. Fork ou copie este repositório para sua conta GitHub
2. Edite `git/.gitconfig` com seu nome e e-mail
3. (Opcional) Ajuste `aliases/.aliases.local` com seus atalhos pessoais
4. Configure o VSCode uma vez:

```json
{
  "dotfiles.repository": "<seu-usuario>/<seu-repo>",
  "dotfiles.targetPath": "~/dotfiles",
  "dotfiles.installCommand": "install.sh"
}
```

A partir daí, qualquer devcontainer que você abrir terá automaticamente
seu gitconfig, starship e aliases pessoais — sem nenhuma configuração adicional.

## O que personalizar

| Arquivo | O que editar |
|---|---|
| `git/.gitconfig` | **Obrigatório** — nome e e-mail |
| `aliases/.aliases.local` | Opcional — seus atalhos pessoais |
| `starship/starship.toml` | Opcional — tema e prompt |
| `zsh/.zshrc.local` | Opcional — vars de ambiente, plugins |

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

## Estrutura

```
dotfiles/
├── install.sh               # entry point — detecta contexto e executa
├── zsh/
│   └── .zshrc.local         # starship, fnm, aliases
├── starship/
│   └── starship.toml        # tema do prompt
├── git/
│   └── .gitconfig           # identidade git + delta
└── aliases/
    └── .aliases.local       # atalhos pessoais
```
