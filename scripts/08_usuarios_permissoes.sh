#!/bin/bash
# ---------------------------------------------------------
# 08_usuarios_permissoes.sh - Usuários, Grupos e Permissões
# Trabalho 03 - Cloud Computing (FreelaCloud DevOps)
# Aluno: Gabriel | Instituição: Unidavi
# ---------------------------------------------------------

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

TARGET_DIR="/app/freelacloud"

# Função obrigatória para criação de credenciais e permissões
configurar_usuarios_permissoes_freelacloud() {
    # Validar permissão de root/sudo
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}[✗] Erro: Este script manipula usuários e precisa rodar como root ou sudo!${NC}"
        return 1
    fi

    echo -e "${BLUE}======================================================${NC}"
    echo -e "${YELLOW}        PROVISIONAMENTO DE ACESSOS - FREELACLOUD      ${NC}"
    echo -e "${BLUE}======================================================${NC}"

    # 1. Criar o grupo do tema
    local grupo="freela_ops"
    echo -e "${YELLOW}[+] Criando o grupo operacional '$grupo'...${NC}"
    if getent group "$grupo" >/dev/null; then
        echo "    Grupo $grupo já existe no container."
    else
        groupadd "$grupo"
        echo -e "${GREEN}    Grupo $grupo cadastrado com sucesso.${NC}"
    fi

    # 2. Criar o usuário do tema
    local usuario="freela_admin"
    echo -e "${YELLOW}[+] Criando o usuário administrador '$usuario'...${NC}"
    if id "$usuario" &>/dev/null; then
        echo "    Usuário $usuario já existe. Garantindo associação ao grupo $grupo..."
        usermod -aG "$grupo" "$usuario"
    else
        # Cria o usuário com diretório home, shell padrão bash e senha criptografada "Freela@123"
        useradd "$usuario" -m -s /bin/bash -p "$(openssl passwd -1 Freela@123)" -G "$grupo"
        echo -e "${GREEN}    Usuário $usuario criado e associado ao grupo $grupo com sucesso.${NC}"
    fi

    # 3. Aplicar propriedades e permissões com justificativa de segurança
    echo -e "\n${YELLOW}[+] Aplicando propriedade e privilégios restritos em $TARGET_DIR...${NC}"
    
    if [ -d "$TARGET_DIR" ]; then
        # chown: define o proprietário como freela_admin e o grupo associado como freela_ops
        chown -R "$usuario:$grupo" "$TARGET_DIR"
        echo -e "${GREEN}[✔] chown: Propriedade alterada para $usuario:$grupo em todos os arquivos de dados.${NC}"

        # chmod: define permissões restritas 770
        # A pasta /app/freelacloud abriga vagas, perfis e contratos confidenciais da plataforma.
        # definir 770 garante que apenas o proprietário e membros do grupo operacional possam ler, escrever ou listar os dados, 
        # bloqueando qualquer outro usuário local não autorizado.
        chmod -R 770 "$TARGET_DIR"
        echo -e "${GREEN}[✔] chmod: Permissões redefinidas para 770 (Dono e Grupo total; Outros nenhum).${NC}"
    else
        echo -e "${RED}[!] Atenção: Pasta do FreelaCloud não localizada. Execute 03_estrutura.sh primeiro.${NC}"
        return 1
    fi

    echo -e "\n${GREEN}[✔] Configuração de privilégios e usuários efetuada com sucesso!${NC}"
    return 0
}

# Invocar a função
configurar_usuarios_permissoes_freelacloud
exit $?
