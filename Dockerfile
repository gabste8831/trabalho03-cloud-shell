# Dockerfile para Ambiente Linux com Servidor Apache
# Trabalho 03 - Cloud Computing

FROM ubuntu:22.04

# Evitar prompts interativos durante a instalação de pacotes
ENV DEBIAN_FRONTEND=noninteractive

# Atualizar repositórios e instalar utilitários necessários
RUN apt-get update && apt-get install -y \
    apache2 \
    sudo \
    curl \
    nano \
    htop \
    tar \
    cron \
    iproute2 \
    procps \
    && rm -rf /var/lib/apt/lists/*

# Definir diretório de trabalho no container
WORKDIR /app

# Copiar a estrutura do projeto para dentro do container
COPY . /app/

# Dar permissão de execução aos scripts bash
RUN chmod +x /app/scripts/*.sh

# Expor a porta padrão do servidor web Apache
EXPOSE 80

# Iniciar o Apache em primeiro plano como processo principal do container
CMD ["apachectl", "-D", "FOREGROUND"]
