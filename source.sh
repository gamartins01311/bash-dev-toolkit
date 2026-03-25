#!/bin/bash

export DEV_USER="$USER"

BASE_DIR="/home/$DEV_USER/desenvolvimento/bash"

SCRIPTS=(
  "$BASE_DIR/alias/java.sh"
  "$BASE_DIR/alias/maven.sh"
)

load_aliases() {
  for file in "${SCRIPTS[@]}"; do
    if [ -f "$file" ]; then
      echo "[BASH] carregando: $file"
      source "$file"
    else
      echo "[ERRO] arquivo não encontrado: $file"
    fi
  done
}

reload_aliases() {
  echo "[BASH] recarregando aliases..."

  load_aliases

  echo "[BASH] reload concluído!"
}

load_aliases

fullreload() {
  source ~/.bashrc
}