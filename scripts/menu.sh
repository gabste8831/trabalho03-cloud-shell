#!/bin/bash
# ---------------------------------------------------------
# menu.sh - Menu Principal Interativo DevOps
# Trabalho 03 - Linux, Shell Script e Cloud Computing
# ---------------------------------------------------------

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Função obrigatória para renderizar o menu e processar a escolha
mostrar_menu() {
    while true; do
        clear
        echo -e "${BLUE}======================================================${NC}"
        echo -e "Criado por: Gabriel"
        echo -e "Instituição: Unidavi"
        echo -e "Tema: FreelaCloud"
        echo -e "${BLUE}===== MENU DEVOPS CLOUD =====${NC}"
        echo -e "1 - Atualizar sistema"
        echo -e "2 - Instalar Apache"
        echo -e "3 - Criar estrutura do projeto"
        echo -e "4 - Realizar backup"
        echo -e "5 - Fazer deploy"
        echo -e "6 - Ver processos"
        echo -e "7 - Monitorar sistema"
        echo -e "8 - Configurar usuários e permissões"
        echo -e "9 - Gerar relatório"
        echo -e "0 - Sair"
        echo -e "${BLUE}======================================================${NC}"
        echo -n "Escolha uma opção: "
        read -r opcao

        case $opcao in
            1)
                echo -e "\n${YELLOW}>> Executando: 01_update.sh${NC}"
                bash "$SCRIPT_DIR/01_update.sh"
                ;;
            2)
                echo -e "\n${YELLOW}>> Executando: 02_apache.sh${NC}"
                bash "$SCRIPT_DIR/02_apache.sh"
                ;;
            3)
                echo -e "\n${YELLOW}>> Executando: 03_estrutura.sh${NC}"
                bash "$SCRIPT_DIR/03_estrutura.sh"
                ;;
            4)
                echo -e "\n${YELLOW}>> Executando: 04_backup.sh${NC}"
                bash "$SCRIPT_DIR/04_backup.sh"
                ;;
            5)
                echo -e "\n${YELLOW}>> Executando: 05_deploy.sh${NC}"
                bash "$SCRIPT_DIR/05_deploy.sh"
                ;;
            6)
                # O script de processos aceita subcomandos. Por padrão, no menu, chamamos o subcomando 'listar'
                # mas também damos a opção do usuário digitar um comando manual se desejar.
                echo -e "\n${YELLOW}>> Gerenciamento de Processos${NC}"
                echo "1 - Listar todos os processos"
                echo "2 - Buscar processo por nome"
                echo "3 - Encerrar processo por PID"
                echo -n "Escolha a ação de processo (ou pressione Enter para voltar): "
                read -r acao_proc
                case $acao_proc in
                    1)
                        bash "$SCRIPT_DIR/06_processos.sh" listar
                        ;;
                    2)
                        echo -n "Digite o nome do processo: "
                        read -r proc_nome
                        bash "$SCRIPT_DIR/06_processos.sh" buscar "$proc_nome"
                        ;;
                    3)
                        echo -n "Digite o PID do processo: "
                        read -r proc_pid
                        bash "$SCRIPT_DIR/06_processos.sh" matar "$proc_pid"
                        ;;
                    *)
                        echo "Retornando ao menu principal..."
                        ;;
                esac
                ;;
            7)
                echo -e "\n${YELLOW}>> Executando: 07_monitoramento.sh${NC}"
                bash "$SCRIPT_DIR/07_monitoramento.sh"
                ;;
            8)
                echo -e "\n${YELLOW}>> Executando: 08_usuarios_permissoes.sh${NC}"
                # Como altera privilégios de arquivos e usuários, roda com sudo se não for root
                if [ "$EUID" -ne 0 ]; then
                    sudo bash "$SCRIPT_DIR/08_usuarios_permissoes.sh"
                else
                    bash "$SCRIPT_DIR/08_usuarios_permissoes.sh"
                fi
                ;;
            9)
                echo -e "\n${YELLOW}>> Executando: 09_relatorio.sh${NC}"
                bash "$SCRIPT_DIR/09_relatorio.sh"
                ;;
            0)
                echo -e "\n${RED}Saindo do Menu DevOps. Até logo!${NC}\n"
                exit 0
                ;;
            *)
                echo -e "\n${RED}Opção inválida! Escolha um número de 0 a 9.${NC}"
                ;;
        esac

        echo -e "\nPressione [Enter] para continuar..."
        read -r
    done
}

# Iniciar o menu
mostrar_menu
