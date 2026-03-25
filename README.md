# 🧰 Bash Dev Toolkit

Conjunto de scripts para facilitar o desenvolvimento no Linux, permitindo:

* Centralizar aliases e funções
* Carregar scripts de forma controlada
* Recarregar sem reiniciar o terminal
* Gerenciar versões de Java automaticamente (estilo SDKMAN simplificado)

---

# 📁 Estrutura do Projeto

```
/home/${SEU_USER}/desenvolvimento/bash/
├── source.sh          # Script principal (loader)
└── alias/
    ├── java.sh        # Gerenciamento de JDKs
    ├── git.sh         # (opcional)
    └── docker.sh      # (opcional)
```

---

# ⚙️ Configuração Inicial

## 1. Adicionar no `.bashrc`

Edite seu arquivo:

```
nano ~/.bashrc
```

Adicione ao final:

```
source ~/desenvolvimento/bash/source.sh
```

Depois aplique:

```
source ~/.bashrc
```

---

# 🧠 Como Funciona

O `source.sh`:

* Define o usuário dinamicamente (`DEV_USER`)
* Define o diretório base dos scripts
* Carrega apenas os scripts definidos manualmente
* Permite reload dinâmico sem reiniciar o terminal

---

# 📜 source.sh (explicação)

## 🔹 Variáveis principais

```
export DEV_USER="$USER"
BASE_DIR="/home/$DEV_USER/desenvolvimento/bash"
```

👉 Remove hardcode de usuário
👉 Funciona em qualquer máquina automaticamente

---

## 🔹 Lista de scripts carregados

```
SCRIPTS=(
  "$BASE_DIR/alias/java.sh"
)
```

👉 Controle total sobre quais scripts serão carregados

---

## 🔹 Funções principais

### `load_aliases`

Carrega todos os scripts definidos:

```
load_aliases
```

---

### `reload_aliases`

Recarrega os scripts sem fechar o terminal:

```
reload_aliases
```

⚠️ Não remove aliases do sistema (evita problemas)

---

# ☕ Gerenciamento de Java

Arquivo: `alias/java.sh`

---

## 📂 Diretório base das JDKs

```
JAVA_BASE="/home/$DEV_USER/opt/java"
```

👉 Basta colocar suas JDKs nesse diretório

Exemplo:

```
/home/gabriel/opt/java/
├── graalvm-jdk-21.0.10+8.1
├── openjdk-17
└── openjdk-11
```

---

## 🚀 Comando principal

### 🔹 Seleção interativa

```
java_set
```

👉 Lista automaticamente todas as JDKs disponíveis

---

### 🔹 Seleção direta (busca parcial)

```
java_set 21
```

ou

```
java_set graalvm
```

👉 Faz match parcial com o nome da pasta

---

## 🔧 O que a função faz

* Detecta automaticamente todas as JDKs
* Permite seleção interativa ou direta
* Atualiza `JAVA_HOME`
* Limpa versões antigas do `PATH`
* Adiciona a nova versão corretamente
* Executa `java -version`

---

## ⚙️ Lógica interna

A aplicação do Java é feita por uma função interna:

```
_java_apply
```

👉 Evita duplicação de código
👉 Garante consistência na troca de versão

---

# 🔄 Recarregar alterações

Sempre que alterar qualquer `.sh`:

```
reload_aliases
```

---

# ➕ Como criar novos scripts

## 1. Criar arquivo

```
nano ~/desenvolvimento/bash/alias/novo.sh
```

---

## 2. Adicionar conteúdo

### Exemplo com alias:

```
alias gs="git status"
alias gp="git push"
```

---

### Exemplo com função:

```
mkcd() {
  mkdir -p "$1" && cd "$1"
}
```

---

## 3. Registrar no `source.sh`

```
SCRIPTS+=("$BASE_DIR/alias/novo.sh")
```

---

## 4. Recarregar

```
reload_aliases
```

---

# ⚠️ Boas práticas

* ❌ Não usar caminhos hardcoded (`/home/user`)
* ✅ Usar `$DEV_USER`
* ❌ Não usar `unalias -a`
* ✅ Preferir funções quando houver lógica
* ✅ Manter scripts organizados por domínio
* ✅ Evitar duplicação de PATH

---

# 🐞 Debug

Execute:

```
reload_aliases
```
