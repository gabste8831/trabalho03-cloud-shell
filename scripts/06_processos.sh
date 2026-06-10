#!/bin/bash
# ---------------------------------------------------------
# 06_processos.sh - Gerenciamento de Processos
# Trabalho 03 - Cloud Computing (FreelaCloud DevOps)
# Aluno: Gabriel | Instituição: Unidavi
# ---------------------------------------------------------

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Função 1: Listar todos os processos ativos
listar_processos() {
    echo -e "${BLUE}======================================================${NC}"
    echo -e "${YELLOW}           LISTANDO PROCESSOS ATIVOS NO CONTAINER     ${NC}"
    echo -e "${BLUE}======================================================${NC}"
    ps aux
}

# Função 2: Buscar processo por nome
buscar_processo() {
    local nome_busca=$1
    if [ -z "$nome_busca" ]; then
        echo -e "${RED}[✗] Erro: Informe o nome do processo a ser buscado.${NC}"
        echo "Exemplo: ./06_processos.sh buscar apache"
        return 1
    fi

    echo -e "${BLUE}======================================================${NC}"
    echo -e "${YELLOW}     BUSCANDO PROCESSOS CORRESPONDENTES A: $nome_busca ${NC}"
    echo -e "${BLUE}======================================================${NC}"
    
    local resultado=$(ps aux | grep -i "$nome_busca" | grep -v grep | grep -v "06_processos.sh")
    
    if [ -n "$resultado" ]; then
        echo -e "${GREEN}Processos encontrados:${NC}"
        echo "$resultado"
    else
        echo -e "${RED}[!] Nenhum processo correspondente a '$nome_busca' foi encontrado.${NC}"
    fi
}

# Função 3: Encerrar processo por PID
matar_processo() {
    local pid_alvo=$1
    
    # Impedir encerramento sem PID informado
    if [ -z "$pid_alvo" ]; then
        echo -e "${RED}[✗] AVISO DE SEGURANÇA: Operação cancelada. PID não informado!${NC}"
        echo "Exemplo de uso: ./06_processos.sh matar <PID>"
        return 1
    fi

    # Mensagens de segurança
    echo -e "${RED}⚠️  AVISO DE SEGURANÇA: Você está prestes a encerrar o processo PID $pid_alvo.${NC}"
    echo -e "${YELLOW}[+] Verificando se o PID $pid_alvo existe...${NC}"

    if ! ps -p "$pid_alvo" > /dev/null; then
        echo -e "${RED}[✗] Erro: O processo com PID $pid_alvo não existe ou já foi finalizado.${NC}"
        return 1
    fi

    # Tenta encerrar graciosamente primeiro
    echo -e "${YELLOW}[+] Enviando sinal SIGTERM (terminação graciosa) ao PID $pid_alvo...${NC}"
    kill -15 "$pid_alvo" 2>/dev/null
    sleep 1

    # Verifica se ainda está vivo e força se necessário
    if ps -p "$pid_alvo" > /dev/null; then
        echo -e "${YELLOW}[!] O processo não respondeu. Enviando SIGKILL (forçar encerramento)...${NC}"
        kill -9 "$pid_alvo" 2>/dev/null
    fi

    # Validação final
    if ! ps -p "$pid_alvo" > /dev/null; then
        echo -e "${GREEN}[✔] Processo com PID $pid_alvo encerrado com sucesso!${NC}"
    else
        echo -e "${RED}[✗] Falha ao encerrar o processo PID $pid_alvo (permissão negada).${NC}"
    fi
}

# Tratamento dos parâmetros de entrada
case "$1" in
    listar)
        listar_processos
        ;;
    buscar)
        buscar_processo "$2"
        ;;
    matar)
        matar_processo "$2"
        ;;
    *)
        echo -e "${YELLOW}Uso: $0 [listar | buscar <nome> | matar <PID>]${NC}"
        echo ""
        echo "  listar       - Lista todos os processos ativos no container"
        echo "  buscar <nom> - Procura processos ativos por correspondência de nome"
        echo "  matar <PID>  - Encerra com segurança um processo usando o PID especificado"
        exit 1
        ;;
esac
