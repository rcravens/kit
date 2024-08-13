FROM ubuntu:22.04 AS base_image

ARG PHP_VERSION
RUN echo $PHP_VERSION

ARG TARGETARCH
RUN echo $TARGETARCH


# Upgrade and update
RUN apt-get update
RUN apt-get upgrade -y

# Add packages that need to be kept on the system
RUN apt-get install -y software-properties-common curl gnupg debian-keyring debian-archive-keyring apt-transport-https
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install -y ca-certificates build-essential dos2unix gcc git git-lfs libmcrypt4 libpcre3-dev libpng-dev chrony make pv
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install -y python3-pip re2c supervisor unattended-upgrades whois vim cifs-utils bash-completion zsh zip unzip expect
RUN DEBIAN_FRONTEND=noninteractive TZ=Etc/UTC apt-get install -y unixodbc sqlite3 slapd ldap-utils samba nano

# Add SQL Server ODBC support
RUN if [ "$TARGETARCH" = "amd64" ]; then  \
		# mssql odbc for database connection version 17
		#curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/msodbcsql17_17.5.2.1-1_amd64.apk \
		#	&& curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/mssql-tools_17.5.2.1-1_amd64.apk \
		#	&& apk add --allow-untrusted msodbcsql17_17.5.2.1-1_amd64.apk \
		#	&& apk add --allow-untrusted mssql-tools_17.5.2.1-1_amd64.apk \
		# mssql odbc for database connection version 18
    	curl https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc \
    	&& curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list | tee /etc/apt/sources.list.d/mssql-release.list \
    	&& apt-get update \
    	&& ACCEPT_EULA=Y apt-get install -y msodbcsql18 \
	    && apt-get install -y unixodbc-dev; \
	elif [ "$TARGETARCH" = "arm64" ]; then  \
    	curl https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc \
    	&& curl https://packages.microsoft.com/config/ubuntu/$(lsb_release -rs)/prod.list | tee /etc/apt/sources.list.d/mssql-release.list \
	    && apt-get update \
	    && ACCEPT_EULA=Y apt-get install -y msodbcsql18 \
	    && apt-get install -y unixodbc-dev; \
	fi

# Install Nginx
RUN apt install -y nginx \
    #&& rm /etc/nginx/sites-enabled/default \
    && service nginx restart;

# Install PHP Version
RUN apt-add-repository ppa:ondrej/php -y \
    && apt-get update -y \
    && apt-get install -y --allow-change-held-packages \
    php-imagick php-memcached php-redis php-xdebug php-dev imagemagick mcrypt \
    && apt-get install -y --allow-change-held-packages \
    php${PHP_VERSION} php${PHP_VERSION}-bcmath php${PHP_VERSION}-bz2 php${PHP_VERSION}-cgi php${PHP_VERSION}-cli php${PHP_VERSION}-common php${PHP_VERSION}-curl php${PHP_VERSION}-dba php${PHP_VERSION}-dev \
    php${PHP_VERSION}-enchant php${PHP_VERSION}-fpm php${PHP_VERSION}-gd php${PHP_VERSION}-gmp php${PHP_VERSION}-imap php${PHP_VERSION}-interbase php${PHP_VERSION}-intl php${PHP_VERSION}-ldap \
    php${PHP_VERSION}-mbstring php${PHP_VERSION}-mysql php${PHP_VERSION}-odbc php${PHP_VERSION}-opcache php${PHP_VERSION}-pgsql php${PHP_VERSION}-phpdbg php${PHP_VERSION}-pspell php${PHP_VERSION}-readline \
    php${PHP_VERSION}-snmp php${PHP_VERSION}-soap php${PHP_VERSION}-sqlite3 php${PHP_VERSION}-sybase php${PHP_VERSION}-tidy php${PHP_VERSION}-xdebug php${PHP_VERSION}-xml php${PHP_VERSION}-xmlrpc php${PHP_VERSION}-xsl \
    php${PHP_VERSION}-zip php${PHP_VERSION}-memcached php${PHP_VERSION}-redis;

# Install Composer
RUN curl -s https://getcomposer.org/installer | php \
	&& mv composer.phar /bin/composer.phar \
	&& alias composer='php /bin/composer.phar'

# Install Node, NPM, and other JS libs
RUN curl -fsSL https://deb.nodesource.com/setup_21.x | bash - \
    && apt-get update -y \
    && apt-get install -y nodejs \
    && npm install -g npm \
    && npm install -g gulp-cli \
    && npm install -g bower \
    && npm install -g yarn \
    && npm install -g grunt-cli


RUN echo 'alias composer="php /bin/composer.phar"' >> ~/.bashrc


# ---------------------------- MULTISTAGE BUILD ----------------------------------------

FROM base_image AS app_image

ARG APP_DOMAIN
RUN echo $APP_DOMAIN

ARG PATH_TO_CODE
RUN echo $PATH_TO_CODE

ARG CODE_REPO_URL
RUN echo $CODE_REPO_URL


# ---------------------------- CODE ----------------------------------------

# Create code directory and copy in the code
RUN rm -rf /var/www/html
RUN mkdir -p /var/www/html
RUN git clone ${CODE_REPO_URL} /var/www/html
COPY ./laravel/.env.prod /var/www/html/.env
RUN chown -R www-data:www-data /var/www

WORKDIR /var/www/html
USER www-data
RUN php /bin/composer.phar install
RUN php artisan key:generate
RUN npm install
RUN npm run build
USER root

# ---------------------------- PHP ----------------------------------------
COPY ./php/www-prod.conf /etc/php/8.3/fpm/pool.d/www.conf
COPY ./php/php.ini /etc/php/8.3/fpm/php.ini
COPY ./php/php.ini /etc/php/8.3/cli/php.ini
RUN mv /etc/ldap/ldap.conf /etc/ldap/ldap.conf.bak
COPY ./php/ldap.conf /etc/etc/ldap.conf
RUN mkdir -p /run/php && touch /run/php/php8.3-fpm.sock
RUN chown -R www-data:www-data /run/php
RUN ln -sf /usr/sbin/php-fpm${PHP_VERSION} /usr/sbin/php-fpm


# ---------------------------- NGINX ----------------------------------------
# Setup nginx
# user: www-data
RUN mkdir -p /var/lib/nginx/tmp /var/log/nginx
# Copy in the nginx.conf file
RUN rm -rf /etc/nginx/sites-available/default.conf
COPY ./nginx/web_site_prod.conf /etc/nginx/sites-available/default
# Create self-signed certificate for HTTPS support
RUN mkdir -p /etc/nginx/certs
COPY ./nginx/certs/ /etc/nginx/certs/
RUN cd /etc/nginx/certs && chmod +x create-ca.sh && ./create-ca.sh && chmod +x create-certificate.sh && ./create-certificate.sh "${APP_DOMAIN}"
RUN rm -rf /etc/nginx/certs.app.* && \
cp /etc/nginx/certs/${APP_DOMAIN}.crt /etc/nginx/certs/app.crt && \
cp /etc/nginx/certs/${APP_DOMAIN}.key /etc/nginx/certs/app.key

# ---------------------------- CRON ----------------------------------------
#RUN apt install cron
#COPY ./php/crontab /etc/crontabs/root

# ---------------------------- ENTRY POINT ----------------------------------------
COPY entrypoint-prod.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]