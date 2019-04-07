FROM webdevops/php-apache-dev:7.1

RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
RUN curl https://packages.microsoft.com/config/debian/8/prod.list > /etc/apt/sources.list.d/mssql-release.list

RUN apt-get update

RUN ACCEPT_EULA=Y apt-get install -y msodbcsql && \ 
    apt-get install -y unixodbc unixodbc-dev libgss3 odbcinst locales && \
    rm -rf /var/lib/apt/lists/*

RUN echo "deb http://security.debian.org/debian-security jessie/updates main" >> /etc/apt/sources.list && \ 
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install libssl1.0.0

RUN pecl install pdo_sqlsrv-5.2.0

RUN echo extension=pdo_sqlsrv.so >> /opt/docker/etc/php/php.webdevops.ini

# ssh
ENV SSH_PASSWD "root:Docker!"
RUN apt-get update \
        && apt-get install -y --no-install-recommends dialog \
        && apt-get update \
	&& apt-get install -y --no-install-recommends openssh-server \
	&& echo "$SSH_PASSWD" | chpasswd 

COPY sshd_config /etc/ssh/

EXPOSE 8000 2222
