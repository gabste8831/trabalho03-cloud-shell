#!/bin/bash
# ---------------------------------------------------------
# 04_backup.sh - Backup Automatizado da Plataforma
# Trabalho 03 - Cloud Computing (FreelaCloud DevOps)
# Aluno: Gabriel | Instituição: Unidavi
# ---------------------------------------------------------

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Variáveis obrigatórias para origem e destino
ORIGEM="/app/freelacloud"
DESTINO="/app/backups"
LOG_FILE="/app/logs/backup.log"

mkdir -p "$DESTINO"
mkdir -p "$(dirname "$LOG_FILE")"

# Função obrigatória para a rotina de backup
realizar_backup() {
    echo -e "${YELLOW}[+] [FreelaCloud] Iniciando rotina de backup de segurança...${NC}"
    echo "    Origem: $ORIGEM"
    echo "    Destino: $DESTINO"

    # Validar se o diretório de origem existe e não está vazio
    if [ ! -d "$ORIGEM" ] || [ -z "$(ls -A "$ORIGEM")" ]; then
        echo -e "${RED}[✗] Diretório de origem '$ORIGEM' não existe ou está vazio. Backup abortado!${NC}"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] BACKUP: Abortado (Origem vazia ou inexistente)" >> "$LOG_FILE"
        return 1
    fi

    # Formatação de data e hora para o nome do arquivo
    local timestamp=$(date +"%Y-%m-%d_%H-%M")
    local arquivo_backup="$DESTINO/backup_freelacloud_$timestamp.tar.gz"

    echo -e "${YELLOW}[+] Compactando dados em tarball...${NC}"
    
    # Compactar e logar
    if tar -czf "$arquivo_backup" -C "$(dirname "$ORIGEM")" "$(basename "$ORIGEM")" >> "$LOG_FILE" 2>&1; then
        
        # Validar se o arquivo de backup foi de fato criado e possui tamanho > 0
        if [ -f "$arquivo_backup" ] && [ -s "$arquivo_backup" ]; then
            local tamanho=$(du -sh "$arquivo_backup" | cut -f1)
            echo -e "${GREEN}[✔] Backup criado com sucesso!${NC}"
            echo -e "${GREEN}    Arquivo: $(basename "$arquivo_backup")${NC}"
            echo -e "${GREEN}    Tamanho: $tamanho${NC}"
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] BACKUP: Sucesso | Arquivo: $(basename "$arquivo_backup") | Tamanho: $tamanho" >> "$LOG_FILE"
            return 0
        else
            echo -e "${RED}[✗] O arquivo de backup foi gerado, mas está corrompido ou vazio.${NC}"
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] BACKUP: Erro (Arquivo vazio ou inválido)" >> "$LOG_FILE"
            return 1
        fi
    else
        echo -e "${RED}[✗] Erro crítico ao executar o utilitário tar.${NC}"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] BACKUP: Erro crítico no utilitário tar" >> "$LOG_FILE"
        return 1
    fi
}

# Invocar a rotina
realizar_backup
exit $?
