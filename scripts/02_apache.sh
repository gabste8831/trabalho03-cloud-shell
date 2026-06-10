#!/bin/bash
# ---------------------------------------------------------
# 02_apache.sh - Instalação e Validação do Apache
# Trabalho 03 - Cloud Computing (FreelaCloud DevOps)
# Aluno: Gabriel | Instituição: Unidavi
# ---------------------------------------------------------

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_FILE="$BASE_DIR/logs/apache_setup.log"

mkdir -p "$(dirname "$LOG_FILE")"

# Função 1: Instalar o Apache caso não exista
instalar_apache() {
    echo -e "${YELLOW}[+] [FreelaCloud] Verificando se o Apache2 está instalado...${NC}"
    if ! command -v apache2 &> /dev/null; then
        echo -e "${YELLOW}[!] Apache2 não instalado. Iniciando instalação...${NC}"
        apt-get update -y >> "$LOG_FILE" 2>&1
        apt-get install -y apache2 >> "$LOG_FILE" 2>&1
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}[✔] Apache2 instalado com sucesso!${NC}"
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] INSTALACAO: Apache2 instalado com sucesso" >> "$LOG_FILE"
        else
            echo -e "${RED}[✗] Falha na instalação do Apache2. Verifique os logs em logs/apache_setup.log.${NC}"
            echo "[$(date '+%Y-%m-%d %H:%M:%S')] INSTALACAO: Erro na instalacao" >> "$LOG_FILE"
            return 1
        fi
    else
        echo -e "${GREEN}[✔] Apache2 já está instalado no container.${NC}"
    fi
    return 0
}

# Função 2: Iniciar e verificar se o Apache está em execução
verificar_apache() {
    echo -e "${YELLOW}[+] [FreelaCloud] Inicializando e validando serviço do Apache...${NC}"
    # Iniciar o serviço se inativo
    apachectl start 2>> "$LOG_FILE" || service apache2 start 2>> "$LOG_FILE"
    
    # Validar se o processo está em execução
    if ps aux | grep -v grep | grep apache2 > /dev/null; then
        echo -e "${GREEN}[✔] Servidor Apache está em execução ativa.${NC}"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] SERVICO: Apache ativo e rodando" >> "$LOG_FILE"
        return 0
    else
        echo -e "${RED}[✗] Apache não está rodando. Falha ao ativar serviço.${NC}"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] SERVICO: Apache inativo" >> "$LOG_FILE"
        return 1
    fi
}

# Função 3: Exibir a versão do Apache instalada
versao_apache() {
    if command -v apache2 &> /dev/null; then
        local version=$(apache2 -v | head -n 1)
        echo -e "${GREEN}[✔] Versão do Apache: $version${NC}"
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] VERSAO: $version" >> "$LOG_FILE"
    else
        echo -e "${RED}[✗] Apache não está instalado, impossível obter versão.${NC}"
    fi
}

# Execução ordenada das funções
instalar_apache
if [ $? -eq 0 ]; then
    verificar_apache
    versao_apache
else
    exit 1
fi
