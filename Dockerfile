FROM ubuntu:22.04
MAINTAINER Thuy Dinh <thuydx@zendgroup.vn>
LABEL Author="Thuy Dinh" Description="A comprehensive docker image to build nginx"


# Stop dpkg-reconfigure tzdata from prompting for input
ENV DATE_TIMEZONE=UTC \
    ACCEPT_EULA=Y \
    NODE_VERSION=18.4.0 \
    NVM_DIR=/root/.nvm \
    DEBIAN_FRONTEND=noninteractive

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Set working directory
WORKDIR /var/www

# Install dependencies
RUN sed -i 's|http://|http://vn.|g' /etc/apt/sources.list
RUN apt-get update && apt-get install -y software-properties-common && \
    add-apt-repository ppa:ondrej/php
RUN apt-get update && apt-get -y install && \
    apt-get -y install build-essential \
        libpng-dev \
        libfreetype6-dev \
        locales \
        zip \
        libzip-dev \
        jpegoptim optipng pngquant gifsicle \
        vim \
        unzip \
        git \
        curl \
        openssl \
        bash \
        make \
        strace \
        sudo
RUN apt-get update && apt-get install -y \
    nginx \
    supervisor

#  # cleanup
#  && rm -rf /var/cache/apk/* /tmp/* /var/tmp/* /usr/share/doc/* /usr/share/man/*
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Add user for application
RUN groupadd -g 1000 dev
RUN useradd -u 1000 -ms /bin/bash -g dev -G sudo -p $(openssl passwd -1 dev) dev
RUN echo 'root:Docker!' | chpasswd


#### NVM - NODEJS ####
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version


# nginx config
COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf

# supervisor service config
COPY ./supervisor/supervisord.conf /etc/supervisor/supervisord.conf
COPY ./supervisor/conf.d/ /etc/supervisor/conf.d/

EXPOSE 9000 9003 22
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

CMD ["supervisord", "-n", "-j", "/supervisord.pid", "-c", "/etc/supervisor/supervisord.conf"]
