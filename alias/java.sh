#!/bin/bash

JAVA_BASE="/home/$DEV_USER/opt/java"

java_set() {
  local TARGET="$1"

  if [ ! -d "$JAVA_BASE" ]; then
    echo "Diretório base não encontrado: $JAVA_BASE"
    return 1
  fi

  local jdks=()
  while IFS= read -r dir; do
    jdks+=("$(basename "$dir")")
  done < <(find "$JAVA_BASE" -maxdepth 1 -mindepth 1 -type d | sort)

  if [ ${#jdks[@]} -eq 0 ]; then
    echo "Nenhuma JDK encontrada em $JAVA_BASE"
    return 1
  fi

  if [ -n "$TARGET" ]; then
    for jdk in "${jdks[@]}"; do
      if [[ "$jdk" == *"$TARGET"* ]]; then
        _java_apply "$jdk"
        return 0
      fi
    done

    echo "Nenhuma JDK encontrada com: $TARGET"
  fi

  echo "Selecione uma JDK:"
  local i=1
  for jdk in "${jdks[@]}"; do
    echo "[$i] $jdk"
    ((i++))
  done

  read -p "Escolha um número: " choice

  if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "${#jdks[@]}" ]; then
    echo "Opção inválida"
    return 1
  fi

  local selected="${jdks[$((choice-1))]}"
  _java_apply "$selected"
}

_java_apply() {
  local jdk="$1"

  export JAVA_HOME="$JAVA_BASE/$jdk"

  export PATH="$(echo "$PATH" | sed -E "s#:$JAVA_BASE/[^:]+/bin##g")"

  export PATH="$JAVA_HOME/bin:$PATH"

  echo "Usando JDK: $jdk"
  echo "JAVA_HOME=$JAVA_HOME"

  java -version
}