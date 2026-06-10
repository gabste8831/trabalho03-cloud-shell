#!/bin/bash
# ---------------------------------------------------------
# 07_monitoramento.sh - Monitoramento do Sistema
# Trabalho 03 - Cloud Computing (FreelaCloud DevOps)
# Aluno: Gabriel | Instituição: Unidavi
# ---------------------------------------------------------

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_FILE="$BASE_DIR/logs/monitoramento.log"

mkdir -p "$(dirname "$LOG_FILE")"

# Limites de Alerta (%)
LIMITE_ALERTA=80

# Função obrigatória de monitoramento
coletar_metricas() {
    local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
    echo -e "${BLUE}======================================================${NC}"
    echo -e "${YELLOW}           MONITORAMENTO DE RECURSOS DO CONTAINER     ${NC}"
    echo -e "${BLUE}======================================================${NC}"
    echo "Coleta realizada em: $timestamp"
    echo ""

    # 1. Obter Uso de Disco
    local disk_pct=$(df -h / | tail -n 1 | awk '{print $5}' | tr -d '%')
    local disk_free=$(df -h / | tail -n 1 | awk '{print $4}')

    if [ "$disk_pct" -gt "$LIMITE_ALERTA" ]; then
        echo -e "${RED}[ALERTA] Uso de Disco elevado: $disk_pct% utilizado (Livre: $disk_free)${NC}"
        echo "[$timestamp] [ALERTA] Disco: $disk_pct%" >> "$LOG_FILE"
    else
        echo -e "${GREEN}[OK] Uso de Disco: $disk_pct% (Livre: $disk_free)${NC}"
        echo "[$timestamp] [OK] Disco: $disk_pct%" >> "$LOG_FILE"
    fi

    # 2. Obter Uso de RAM
    local mem_total mem_free mem_used mem_pct
    if command -v free &> /dev/null; then
        mem_total=$(free -m | awk '/Mem:/ {print $2}')
        mem_used=$(free -m | awk '/Mem:/ {print $3}')
        mem_pct=$(( mem_used * 100 / mem_total ))
    else
        # Fallback lendo procfs se free não estiver no container
        local mem_total_kb=$(grep MemTotal /proc/meminfo | awk '{print $2}')
        local mem_free_kb=$(grep MemFree /proc/meminfo | awk '{print $2}')
        mem_total=$((mem_total_kb / 1024))
        local mem_free=$((mem_free_kb / 1024))
        mem_used=$((mem_total - mem_free))
        mem_pct=$(( mem_used * 100 / mem_total ))
    fi

    if [ "$mem_pct" -gt "$LIMITE_ALERTA" ]; then
        echo -e "${RED}[ALERTA] Uso de memória acima de $LIMITE_ALERTA%: $mem_pct% (${mem_used}MB / ${mem_total}MB)${NC}"
        echo "[$timestamp] [ALERTA] RAM: $mem_pct%" >> "$LOG_FILE"
    else
        echo -e "${GREEN}[OK] Uso de memória RAM: $mem_pct% (${mem_used}MB / ${mem_total}MB)${NC}"
        echo "[$timestamp] [OK] RAM: $mem_pct%" >> "$LOG_FILE"
    fi

    # 3. Obter Uso de CPU
    # Coleta de carga média de CPU (1 minuto) convertida para porcentagem fictícia ou carga real
    local cpu_load=$(cat /proc/loadavg | awk '{print $1}')
    # Simula percentual aproximado multiplicando a carga pelo número de cores se necessário, 
    # ou exibe a carga média diretamente
    echo -e "${GREEN}[OK] Carga de CPU (Load Average - 1 min): $cpu_load${NC}"
    echo "[$timestamp] [OK] CPU Load: $cpu_load" >> "$LOG_FILE"

    # 4. Status do Apache
    if ps aux | grep -v grep | grep apache2 > /dev/null; then
        echo -e "${GREEN}[OK] Apache em execução${NC}"
        echo "[$timestamp] [OK] Apache ativo" >> "$LOG_FILE"
    else
        echo -e "${RED}[ALERTA] Apache NÃO está em execução!${NC}"
        echo "[$timestamp] [ALERTA] Apache inativo" >> "$LOG_FILE"
    fi
    echo -e "${BLUE}======================================================${NC}"
}

# Chamar a função
coletar_metricas
exit 0
