#!/bin/bash
# ---------------------------------------------------------
# 03_estrutura.sh - Estrutura de Diretórios Temática
# Trabalho 03 - Cloud Computing (FreelaCloud DevOps)
# Aluno: Gabriel | Instituição: Unidavi
# ---------------------------------------------------------

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

BASE_PATH="/app/freelacloud"

# Função obrigatória para criação da estrutura
criar_estrutura_freelacloud() {
    echo -e "${YELLOW}[+] [FreelaCloud] Iniciando preparação dos diretórios de infraestrutura...${NC}"

    # Limpeza segura se o diretório antigo já existir
    if [ -d "$BASE_PATH" ]; then
        echo -e "${YELLOW}[!] Removendo estrutura antiga em $BASE_PATH com segurança...${NC}"
        rm -rf "$BASE_PATH"
    fi

    # Criando os novos diretórios temáticos da plataforma de freelancer
    mkdir -p "$BASE_PATH/vagas"      # JSONs de vagas de projetos postadas
    mkdir -p "$BASE_PATH/perfis"     # JSONs de perfis profissionais de freelancers
    mkdir -p "$BASE_PATH/contratos"  # Documentos e contratos de alocação
    mkdir -p "$BASE_PATH/logs"       # Logs da aplicação em execução
    mkdir -p "$BASE_PATH/backups"    # Backups internos da aplicação

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}[✔] Estrutura de diretórios criada com sucesso sob $BASE_PATH!${NC}"
    else
        echo -e "${RED}[✗] Falha catastrófica ao criar estrutura de pastas.${NC}"
        return 1
    fi

    # Criar arquivos iniciais de template para simular dados da plataforma
    echo -e "${YELLOW}[+] Gerando templates iniciais de vagas e perfis...${NC}"
    
    cat <<EOF > "$BASE_PATH/vagas/vaga_desenvolvedor_node.json"
{
  "id": 1,
  "titulo": "Desenvolvedor Backend Node.js / Prisma",
  "descricao": "Desenvolvimento do CRUD de microserviços e persistência com PostgreSQL para o FreelaCloud.",
  "remuneracao": "R$ 120/hora",
  "status": "ABERTA"
}
EOF

    cat <<EOF > "$BASE_PATH/perfis/perfil_freelancer_template.json"
{
  "id": 101,
  "nome": "Carlos Silva",
  "habilidades": ["Node.js", "Docker", "Prisma", "PostgreSQL", "Next.js"],
  "disponibilidade": "Imediata",
  "avaliacao": 4.9
}
EOF

    cat <<EOF > "$BASE_PATH/contratos/contrato_modelo.txt"
======================================================
  CONTRATO DE PRESTAÇÃO DE SERVIÇOS - FREELACLOUD
======================================================
Prestador: Carlos Silva
Contratante: Cliente Cloud Teste
Objeto: Desenvolvimento de API de CRUD conteinerizada
Status: Assinado e Ativo
======================================================
EOF

    echo -e "${GREEN}[✔] Arquivos de simulação criados com sucesso!${NC}"
    return 0
}

# Chamando a função
criar_estrutura_freelacloud

# Exibir a árvore de diretórios criada
echo -e "\n${YELLOW}[+] Estrutura finalizada em $BASE_PATH:${NC}"
if command -v tree &> /dev/null; then
    tree "$BASE_PATH"
else
    ls -laR "$BASE_PATH" | grep -v "total"
fi

echo -e "\n${GREEN}[✔] Script 03_estrutura.sh concluído.${NC}"
