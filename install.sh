#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log()  { echo -e "\033[0;34m[dotfiles]\033[0m $*"; }
ok()   { echo -e "\033[0;32m[dotfiles]\033[0m $*"; }
warn() { echo -e "\033[0;33m[dotfiles]\033[0m $*"; }

need_cmd() { command -v "$1" >/dev/null 2>&1; }

# --- Detecta contexto ---
is_container() {
  [ -f /.dockerenv ] || grep -q "docker\|lxc\|containerd" /proc/1/cgroup 2>/dev/null
}

is_wsl() {
  grep -qi "microsoft\|wsl" /proc/version 2>/dev/null
}

# --- Symlinks ---
link() {
  local src="$1" dst="$2"
  mkdir -p "$(dirname "$dst")"
  if [ -f "$dst" ] && [ ! -L "$dst" ]; then
    warn "Backup: $dst → $dst.bak"
    mv "$dst" "$dst.bak"
  fi
  ln -sf "$src" "$dst"
  ok "Linked: $dst"
}

# --- Instala ferramenta se não existir ---
ensure_apt() {
  local pkg="$1"
  if ! need_cmd "$pkg"; then
    log "Instalando $pkg..."
    sudo apt-get update -q && sudo apt-get install -y "$pkg"
  else
    ok "$pkg já instalado"
  fi
}

ensure_starship() {
  if ! need_cmd starship; then
    log "Instalando starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- --yes
  else
    ok "starship já instalado"
  fi
}

ensure_fnm() {
  if ! need_cmd fnm; then
    log "Instalando fnm..."
    curl -fsSL https://fnm.vercel.app/install | bash
  else
    ok "fnm já instalado"
  fi
}

ensure_zsh() {
  if ! need_cmd zsh; then
    log "Instalando zsh..."
    sudo apt-get update -q && sudo apt-get install -y zsh
  else
    ok "zsh já instalado"
  fi
}

ensure_ohmyzsh() {
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    log "Instalando oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
      "" --unattended
  else
    ok "oh-my-zsh já instalado"
  fi
}

ensure_eza() {
  if ! need_cmd eza; then
    log "Instalando eza..."
    EZA_VERSION=$(curl -s https://api.github.com/repos/eza-community/eza/releases/latest \
      | grep '"tag_name"' | cut -d'"' -f4)
    curl -Lo /tmp/eza.tar.gz \
      "https://github.com/eza-community/eza/releases/download/${EZA_VERSION}/eza_x86_64-unknown-linux-gnu.tar.gz"
    sudo tar -xzf /tmp/eza.tar.gz -C /usr/local/bin eza
    rm /tmp/eza.tar.gz
  else
    ok "eza já instalado"
  fi
}

ensure_bat() {
  if ! need_cmd bat && ! need_cmd batcat; then
    log "Instalando bat..."
    sudo apt-get update -q && sudo apt-get install -y bat
    # Ubuntu/Debian instalam como batcat
    if need_cmd batcat && ! need_cmd bat; then
      sudo ln -sf "$(which batcat)" /usr/local/bin/bat
    fi
  else
    ok "bat já instalado"
  fi
}

ensure_delta() {
  if ! need_cmd delta; then
    log "Instalando git-delta..."
    sudo apt-get update -q && sudo apt-get install -y git-delta
  else
    ok "delta já instalado"
  fi
}

ensure_rg() {
  if ! need_cmd rg; then
    log "Instalando ripgrep..."
    sudo apt-get update -q && sudo apt-get install -y ripgrep
  else
    ok "ripgrep já instalado"
  fi
}

# =============================================================================
# MAIN
# =============================================================================

if is_container; then
  log "Contexto: devcontainer"
  log "Imagem base já tem: zsh, fnm, node, eza, bat, rg, delta"
  log "Aplicando apenas configs pessoais..."
else
  log "Contexto: WSL2 / máquina física"
  log "Instalando ferramentas necessárias..."

  ensure_zsh
  ensure_ohmyzsh
  ensure_starship
  ensure_fnm
  ensure_eza
  ensure_bat
  ensure_delta
  ensure_rg
  ensure_apt fzf
  ensure_apt jq

  # Muda shell padrão para zsh se necessário
  if [ "$SHELL" != "$(which zsh)" ]; then
    log "Mudando shell padrão para zsh..."
    chsh -s "$(which zsh)"
  fi
fi

# --- Configs pessoais (aplicadas em qualquer contexto) ---
log "Aplicando configs pessoais..."

# starship
ensure_starship  # garante que está instalado mesmo no container
link "$DOTFILES_DIR/starship/starship.toml" "$HOME/.config/starship.toml"

# git
link "$DOTFILES_DIR/git/.gitconfig" "$HOME/.gitconfig"

# aliases e zshrc pessoal
link "$DOTFILES_DIR/aliases/.aliases.local"  "$HOME/.aliases.local"
link "$DOTFILES_DIR/zsh/.zshrc.local"        "$HOME/.zshrc.local"

ok "Dotfiles aplicados com sucesso!"
log "Para ativar: exec zsh -l"
