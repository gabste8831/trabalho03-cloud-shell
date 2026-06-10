#!/bin/bash
# ---------------------------------------------------------
# 09_relatorio.sh - Relatório Operacional Automatizado
# Trabalho 03 - Cloud Computing (FreelaCloud DevOps)
# Aluno: Gabriel | Instituição: Unidavi
# ---------------------------------------------------------

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LOG_DIR="$BASE_DIR/logs"
REPORT_FILE="$LOG_DIR/relatorio_execucao.txt"

mkdir -p "$LOG_DIR"

# Função obrigatória de compilação do relatório
gerar_relatorio_operacional() {
    local data_hora=$(date "+%Y-%m-%d %H:%M:%S")
    local host_name=$(hostname)
    
    echo -e "${YELLOW}[+] [FreelaCloud] Gerando relatório operacional consolidado...${NC}"

    {
        echo "======================================================="
        echo "        RELATÓRIO OPERACIONAL DE INFRAESTRUTURA        "
        echo "======================================================="
        echo "Projeto          : FreelaCloud"
        echo "Tema             : Plataforma Freelance para Profissionais"
        echo "Aluno            : Gabriel"
        echo "Instituição      : Unidavi"
        echo "Data e Hora      : $data_hora"
        echo "Container Host   : $host_name"
        echo "Endereço IP (Int): $(hostname -I 2>/dev/null || echo '127.0.0.1')"
        echo "-------------------------------------------------------"
        echo ""

        echo "1. ESPAÇO EM DISCO (SISTEMA DE ARQUIVOS):"
        df -h /
        echo ""

        echo "2. USO DOS DIRETÓRIOS TEMÁTICOS (/app/freelacloud):"
        if [ -d "/app/freelacloud" ]; then
            du -sh /app/freelacloud/* 2>/dev/null || echo "   Estrutura criada, mas vazia de arquivos de dados."
        else
            echo "   [!] Diretório /app/freelacloud não existe no sistema."
        fi
        echo ""

        echo "3. STATUS DO SERVIDOR HTTP APACHE:"
        if ps aux | grep -v grep | grep apache2 > /dev/null; then
            echo "   Status : EM EXECUÇÃO (Ativo)"
            echo "   Versão : $(apache2 -v | head -n 1)"
        else
            echo "   Status : PARADO / INATIVO"
        fi
        echo ""

        echo "4. ÚLTIMOS BACKUPS COMPACTADOS GERADOS:"
        if [ -d "$BASE_DIR/backups" ] && [ -n "$(ls -A "$BASE_DIR/backups")" ]; then
            ls -lh "$BASE_DIR/backups" | grep -v "total" | awk '{print "   - " $9 " (" $5 ")"}'
        else
            echo "   Nenhum arquivo de backup localizado na pasta backups/."
        fi
        echo ""

        echo "5. REGISTROS DE LOGS RECENTES:"
        if [ -f "$LOG_DIR/monitoramento.log" ]; then
            echo "   Últimos registros de monitoramento de hardware:"
            tail -n 5 "$LOG_DIR/monitoramento.log" | awk '{print "     > " $0}'
        else
            echo "   Nenhum log de monitoramento recente cadastrado."
        fi
        echo ""

        echo "6. ARQUIVOS DE FRONTEND PUBLICADOS (DEPLOY):"
        if [ -f "/var/www/html/index.html" ]; then
            echo "   Status: Publicado com sucesso no Apache."
            echo "   Lista de arquivos no Apache (/var/www/html):"
            ls -lh /var/www/html | grep -v "total" | awk '{print "     - " $9 " (Perm: " $1 ")"}'
        else
            echo "   Nenhum index.html encontrado em /var/www/html. Deploy inativo."
        fi
        echo ""

        echo "7. USUÁRIOS E PERMISSÕES PRINCIPAIS:"
        echo "   Grupo Operacional (freela_ops):"
        if getent group freela_ops > /dev/null; then
            echo "     Membros: $(getent group freela_ops | cut -d: -f4)"
        else
            echo "     [!] Grupo freela_ops não encontrado no container."
        fi
        echo ""
        echo "   Propriedades de arquivos em /app/freelacloud:"
        if [ -d "/app/freelacloud" ]; then
            ls -ld /app/freelacloud /app/freelacloud/* | awk '{print "     " $1 " - Prop: " $3 ":" $4 " - " $9}'
        else
            echo "     Diretórios inativos."
        fi
        echo "======================================================="
        echo "Fim do Relatório Operacional."
        echo "======================================================="
    } > "$REPORT_FILE"

    # Exibe no terminal
    cat "$REPORT_FILE"
    echo -e "\n${GREEN}[✔] Relatório operacional gravado com sucesso em logs/$(basename "$REPORT_FILE")${NC}"
}

# Chamar a função
gerar_relatorio_operacional
exit 0
