#!/bin/bash
# ---------------------------------------------------------
# 05_deploy.sh - Deploy do Portal FreelaCloud
# Trabalho 03 - Cloud Computing (FreelaCloud DevOps)
# Aluno: Gabriel | Instituição: Unidavi
# ---------------------------------------------------------

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SOURCE_DIR="$BASE_DIR/source"
TARGET_DIR="/var/www/html"
LOG_FILE="/app/logs/deploy.log"

mkdir -p "$(dirname "$LOG_FILE")"

# Função obrigatória para deploy
executar_deploy_freelacloud() {
    echo -e "${YELLOW}[+] [FreelaCloud] Iniciando deploy do portal administrativo...${NC}"
    echo "    Origem: $SOURCE_DIR"
    echo "    Destino: $TARGET_DIR"

    # Validar se a pasta de origem existe e contém arquivos
    if [ ! -d "$SOURCE_DIR" ] || [ -z "$(ls -A "$SOURCE_DIR")" ]; then
        echo -e "${RED}[✗] Diretório 'source' de origem vazio ou inexistente. Deploy abortado!${NC}"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] DEPLOY: Abortado (Origem inválida)" >> "$LOG_FILE"
        return 1
    fi

    # Garantir que a pasta de destino exista
    mkdir -p "$TARGET_DIR"

    # Limpar o diretório de destino antes de fazer a publicação
    echo -e "${YELLOW}[+] Limpando diretório de destino ($TARGET_DIR)...${NC}"
    rm -rf "${TARGET_DIR:?}"/* >> "$LOG_FILE" 2>&1

    # Copiar os novos arquivos
    echo -e "${YELLOW}[+] Copiando arquivos do FreelaCloud para o servidor web...${NC}"
    cp -R "$SOURCE_DIR"/* "$TARGET_DIR"/ >> "$LOG_FILE" 2>&1

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[✔] Arquivos copiados com sucesso!${NC}"
    else
        echo -e "${RED}[✗] Erro na cópia dos arquivos. Verifique permissões.${NC}"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] DEPLOY: Falha na cópia" >> "$LOG_FILE"
        return 1
    fi

    # Alterar propriedade para www-data do Apache para acesso correto
    chown -R www-data:www-data "$TARGET_DIR" 2>/dev/null

    # Listar os arquivos publicados no terminal
    echo -e "\n${YELLOW}[+] Arquivos publicados no diretório de destino:${NC}"
    ls -la "$TARGET_DIR"

    # Validar se o index.html existe no destino
    if [ -f "$TARGET_DIR/index.html" ]; then
        echo -e "\n${GREEN}[✔] Validação Concluída: 'index.html' existe no destino.${NC}"
        echo -e "${GREEN}    O portal está acessível em http://localhost:8080${NC}"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] DEPLOY: Sucesso" >> "$LOG_FILE"
        return 0
    else
        echo -e "\n${RED}[✗] Falha na validação: 'index.html' não foi encontrado no destino.${NC}"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] DEPLOY: Falha (index.html não encontrado)" >> "$LOG_FILE"
        return 1
    fi
}

# Invocar função
executar_deploy_freelacloud
exit $?
