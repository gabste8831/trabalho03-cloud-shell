#!/bin/bash
# ---------------------------------------------------------
# 01_update.sh - Atualização de Pacotes do Sistema
# Trabalho 03 - Cloud Computing (FreelaCloud DevOps)
# Aluno: Gabriel | Instituição: Unidavi
# ---------------------------------------------------------

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="$BASE_DIR/logs"
LOG_FILE="$LOG_DIR/update.log"

# Garantir que o diretório de logs exista
mkdir -p "$LOG_DIR"

# Função obrigatória para atualizar o sistema
atualizar_sistema() {
    echo -e "${YELLOW}[+] [FreelaCloud] Iniciando atualização de repositórios do container...${NC}"
    
    # Executar o apt-get update e registrar saída no log
    if apt-get update -y > "$LOG_FILE" 2>&1; then
        echo -e "${GREEN}[✔] Repositórios atualizados. Aplicando upgrades de pacotes...${NC}"
        
        # Executar apt-get upgrade silencioso para evitar bloqueios interativos
        if apt-get upgrade -y >> "$LOG_FILE" 2>&1; then
            echo -e "${GREEN}[✔] Pacotes atualizados com sucesso!${NC}"
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] UPDATE: Sucesso" >> "$LOG_FILE"
            return 0
        else
            echo -e "${RED}[✗] Falha ao atualizar pacotes (upgrade). Veja logs/update.log${NC}"
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] UPDATE: Erro no upgrade" >> "$LOG_FILE"
            return 1
        fi
    else
        echo -e "${RED}[✗] Falha ao atualizar lista de repositórios (update). Veja logs/update.log${NC}"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] UPDATE: Erro no update" >> "$LOG_FILE"
        return 1
    fi
}

# Invocar a função
atualizar_sistema
exit $?
