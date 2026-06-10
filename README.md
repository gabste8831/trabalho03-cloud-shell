# Trabalho 03 - Linux, Shell Script e Cloud Computing

## Aluno
Gabriel

## Tema
**FreelaCloud** - Plataforma Freelance para Profissionais

## Descrição do Projeto
O **FreelaCloud** é uma plataforma que conecta freelancers a clientes para contratação de projetos. No Trabalho 02, foi desenvolvida como uma aplicação containerizada em Next.js com banco PostgreSQL. 

Neste Trabalho 03, simulamos o ambiente de DevOps da infraestrutura Linux do FreelaCloud. O projeto cria um ambiente isolado baseado em Ubuntu Server no Docker, simulando o servidor operacional que hospeda o portal estático da plataforma e executa rotinas administrativas essenciais através de Shell Script. Os scripts realizam atualizações de pacotes, deploy de novos builds do portal, monitoramento de saúde de CPU e RAM, criação de contas administrativas locais, backups compactados periódicos das vagas e portfólios, e relatórios operacionais exportáveis.

## Tecnologias Utilizadas
- **Linux Ubuntu 22.04** (Imagem base do container)
- **Docker & Docker Compose** (Orquestração do ambiente local e isolamento)
- **Apache** (Servidor HTTP para hospedagem das páginas)
- **Shell Script (Bash)** (Scripts automatizadores das tarefas DevOps)
- **GitHub** (Hospedagem e versionamento do código-fonte)
- **DockerHub** (Distribuição da imagem do container)

## Estrutura do Projeto
```text
trabalho03-cloud-shell/
├── Dockerfile                  # Especificação do container Ubuntu + Apache + ferramentas
├── docker-compose.yml          # Definição e orquestração de rede, portas e volumes
├── README.md                   # Documentação completa do projeto (este arquivo)
├── scripts/                    # Scripts Shell (.sh) com permissões de execução
│   ├── menu.sh                 # Menu interativo principal (integra todos os scripts)
│   ├── 01_update.sh            # Atualização de pacotes do sistema
│   ├── 02_apache.sh            # Instalação, inicialização e auditoria do Apache
│   ├── 03_estrutura.sh         # Criação de pastas temáticas do FreelaCloud (/app/freelacloud)
│   ├── 04_backup.sh            # Rotina de backups compactados das vagas e perfis
│   ├── 05_deploy.sh            # Implantação e limpeza da pasta de exibição web do Apache
│   ├── 06_processos.sh         # Listagem, busca e encerramento de processos com parâmetros
│   ├── 07_monitoramento.sh     # Coleta de recursos (CPU, RAM, Disco) com alertas coloridos
│   ├── 08_usuarios_permissoes.sh # Provisionamento de grupo (freela_ops) e usuário (freela_admin)
│   └── 09_relatorio.sh         # Consolidação operacional do FreelaCloud em arquivo de log
├── source/                     # Páginas web da aplicação estática do FreelaCloud
│   ├── index.html              # Página Home (Dashboard do FreelaCloud)
│   ├── sobre.html              # Página explicativa de arquitetura
│   └── assets/                 # Recursos de estilo e estilo unificado (style.css)
├── backups/                    # Volume mapeado contendo tarballs de backup
├── logs/                       # Volume contendo relatórios operacionais e monitoramento
└── evidencias/                 # Prints e registros de funcionamento técnico
```

---

## Como Executar

### 1. Iniciar o Ambiente Docker
Execute o comando a seguir no terminal no diretório do projeto para construir a imagem e rodar o container em segundo plano:
```bash
docker compose up -d --build
```

### 2. Acessar o Shell do Container
Para acessar o console interativo do container Ubuntu e executar os scripts, execute:
```bash
docker exec -it trabalho03-linux bash
```

---

## Scripts Disponíveis

| Script | Descrição |
|---|---|
| `scripts/01_update.sh` | Executa a função `atualizar_sistema` para atualizar a base de pacotes via apt. |
| `scripts/02_apache.sh` | Gerencia e instala o Apache, exibindo a versão e o status de funcionamento. |
| `scripts/03_estrutura.sh` | Cria a árvore de pastas temáticas sob `/app/freelacloud` (vagas, perfis, etc.). |
| `scripts/04_backup.sh` | Compacta os dados do FreelaCloud salvando-os em `backups/` com data/hora no nome. |
| `scripts/05_deploy.sh` | Executa o deploy do portal do FreelaCloud limpando `/var/www/html/` primeiro. |
| `scripts/06_processos.sh` | Lista, busca processos do container e mata processos através de PIDs informados. |
| `scripts/07_monitoramento.sh` | Monitora recursos de hardware do container e avisa se atingir limites críticos. |
| `scripts/08_usuarios_permissoes.sh` | Cria o grupo `freela_ops` e usuário `freela_admin` com regras restritas 770. |
| `scripts/09_relatorio.sh` | Consolida todas as métricas e logs em `logs/relatorio_execucao.txt`. |
| `scripts/menu.sh` | Menu Principal DevOps interativo unificado. |

### Como Executar os Scripts Individualmente (Dentro do Container)
```bash
cd /app/scripts
chmod +x *.sh
./01_update.sh
./02_apache.sh
./03_estrutura.sh
./04_backup.sh
./05_deploy.sh
./06_processos.sh
./07_monitoramento.sh
./08_usuarios_permissoes.sh
./09_relatorio.sh
```

### Como Executar o Menu Principal
```bash
./menu.sh
```

---

## Evidências
As capturas de tela e evidências de execução estão localizadas na pasta [/evidencias](file:///c:/Users/gabri/Documentos/Faculdade/7a%20Fase/Cloud%20Computing/Trabalho%2003/trabalho03-cloud-shell/evidencias/).

*   `01_container_executando.png` - Container executando e portas mapeadas.
*   `02_menu_principal.png` - Menu de interface de texto interativo em execução.
*   `03_deploy_sucesso.png` - Deploy realizado e site acessível.
*   `04_monitoramento_alertas.png` - Alertas de disco/memória no terminal.
*   *(Outras imagens organizadas por tarefa na pasta de evidências)*

## DockerHub
A imagem do aplicativo FreelaCloud está disponível em:
*   [gabrielste/freelacloud-app (Docker Hub)](https://hub.docker.com/r/gabrielste/freelacloud-app)

## Uso de IA
- **Ferramenta utilizada**: Gemini (Google AI) incorporado via IDE.
- **Partes em que foi utilizada**: Apoio no planejamento da estrutura, auxílio na estruturação estética premium de estilo CSS e na estruturação lógica das validações com funções bash.
- **Ajustes manuais**: Customização dos caminhos absolutos, alteração de nomes de container para conformidade acadêmica e revisão dos testes das condições lógica de monitoramento de processos.
- **Aprendizado**: Melhor compreensão do comportamento do Apache rodando em foreground no Docker, juntamente com o encadeamento de scripts usando menus interativos e a montagem de volumes para gravação segura de dados gerados.

## Dificuldades Encontradas
1.  **Manipulação de Serviços no Docker**: O comando tradicional `systemctl` não funciona em containers Docker padrão sem systemd. A solução foi gerenciar o serviço através do binário direto `apachectl` ou `service apache2 start` capturando a tabela de processos para validação.
2.  **Permissões de Usuários não-root**: Garantir que as pastas ficassem com permissão restrita `770` sem quebrar o acesso à leitura do deploy do site pelo servidor Apache (usuário `www-data`). Isso foi contornado separando as pastas de infraestrutura internas da plataforma daquelas utilizadas publicamente pelo servidor web.
