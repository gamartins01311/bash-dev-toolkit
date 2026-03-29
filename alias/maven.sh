#!/bin/bash

MAVEN_BASE="/home/$USER/opt/maven"

maven_set() {
  local TARGET="$1"

  if [ ! -d "$MAVEN_BASE" ]; then
    echo "Diretório base não encontrado: $MAVEN_BASE"
    return 1
  fi

  local mavens=()
  while IFS= read -r dir; do
    mavens+=("$(basename "$dir")")
  done < <(find "$MAVEN_BASE" -maxdepth 1 -mindepth 1 -type d | sort)

  if [ ${#mavens[@]} -eq 0 ]; then
    echo "Nenhum Maven encontrado em $MAVEN_BASE"
    return 1
  fi

  if [ -n "$TARGET" ]; then
    for mvn in "${mavens[@]}"; do
      if [[ "$mvn" == *"$TARGET"* ]]; then
        _maven_apply "$mvn"
        return 0
      fi
    done

    echo "Nenhum Maven encontrado com: $TARGET"
  fi

  echo "Selecione uma versão do Maven:"
  local i=1
  for mvn in "${mavens[@]}"; do
    echo "[$i] $mvn"
    ((i++))
  done

  read -p "Escolha um número: " choice

  if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "${#mavens[@]}" ]; then
    echo "Opção inválida"
    return 1
  fi

  local selected="${mavens[$((choice-1))]}"
  _maven_apply "$selected"
}

_maven_apply() {
  local mvn="$1"

  export MAVEN_HOME="$MAVEN_BASE/$mvn"

  export PATH="$(echo "$PATH" | sed -E "s#:$MAVEN_BASE/[^:]+/bin##g")"

  export PATH="$MAVEN_HOME/bin:$PATH"

  echo "Usando Maven: $mvn"
  echo "MAVEN_HOME=$MAVEN_HOME"

  mvn -version
}