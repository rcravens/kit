ARG PHP_VERSION

############################## base_image ##############################
FROM php:${PHP_VERSION}-fpm-alpine AS base_image

ARG TARGETARCH

RUN echo $TARGETARCH

# CREATE USER
RUN addgroup -g 1000 laravel && adduser -G laravel -g laravel -s /bin/sh -D laravel

# UPGRADE / UPDATE
RUN apk upgrade --update

# ADD PACKAGES FOR PHP AND PHP MODULES

# Add packages to the _build_deps_ virtual bundle. These are used only to build
#   the PHP modules and can be deleted later
RUN apk --no-cache --virtual _build_deps_ add \
    ${PHPIZE_DEPS} autoconf file g++ gcc make binutils libc-dev musl-dev libstdc++ libgcc gmp-dev \
    freetype-dev libjpeg-turbo-dev libmcrypt-dev libpng-dev imap-dev openssl-dev libzip-dev curl-dev \
    pcre-dev bzip2-dev libwebp-dev icu-dev ldb-dev openldap-dev \
    oniguruma-dev freetds-dev unixodbc-dev aspell-dev libedit-dev net-snmp-dev libxml2-dev \
    sqlite-dev tidyhtml-dev libxslt-dev zlib-dev libidn2-dev libevent-dev libidn-dev imagemagick-dev \
    libatomic re2c mpc1 gmp libgomp coreutils libltdl gnupg libtool mysql-client

# Add packages that need to be kept on the system
RUN apk add freetds unixodbc sqlite libldap php-ldap samba bash nano openssl supervisor

# mssql odbc for dabase connection version 18
#RUN if [ "$TARGETARCH" = "amd64" ]; then \
#		# mssql odbc for database connection version 17
#		#curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/msodbcsql17_17.5.2.1-1_amd64.apk \
#		#	&& curl -O https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/mssql-tools_17.5.2.1-1_amd64.apk \
#		#	&& apk add --allow-untrusted msodbcsql17_17.5.2.1-1_amd64.apk \
#		#	&& apk add --allow-untrusted mssql-tools_17.5.2.1-1_amd64.apk \
#		# mssql odbc for database connection version 18
#		curl -O https://download.microsoft.com/download/b/9/f/b9f3cce4-3925-46d4-9f46-da08869c6486/msodbcsql18_18.1.1.1-1_amd64.apk \
#		&& curl -O https://download.microsoft.com/download/b/9/f/b9f3cce4-3925-46d4-9f46-da08869c6486/mssql-tools18_18.1.1.1-1_amd64.apk \
#		&& apk add --allow-untrusted msodbcsql18_18.1.1.1-1_amd64.apk \
#		&& apk add --allow-untrusted mssql-tools18_18.1.1.1-1_amd64.apk; \
#    elif [ "$TARGETARCH" = "arm64" ]; then \
#		curl -O https://download.microsoft.com/download/3/5/5/355d7943-a338-41a7-858d-53b259ea33f5/msodbcsql18_18.3.2.1-1_arm64.apk \
#		&& curl -O https://download.microsoft.com/download/3/5/5/355d7943-a338-41a7-858d-53b259ea33f5/mssql-tools18_18.3.1.1-1_arm64.apk \
#		&& apk add --allow-untrusted msodbcsql18_18.3.2.1-1_arm64.apk \
#		&& apk add --allow-untrusted mssql-tools18_18.3.1.1-1_arm64.apk; \
#    fi;

#RUN pecl install sqlsrv pdo_sqlsrv \
#	&& docker-php-ext-enable --ini-name 30-sqlsrv.ini sqlsrv \
#	&& docker-php-ext-enable --ini-name 35-pdo_sqlsrv.ini pdo_sqlsrv

RUN pecl install redis \
	&& docker-php-ext-enable redis

RUN docker-php-ext-configure gd --with-jpeg --with-webp --with-freetype \
    && docker-php-ext-configure ldap

RUN docker-php-ext-install \
    pdo pdo_mysql bcmath bz2 dba gd gmp imap intl ldap \
	opcache pcntl pspell snmp soap tidy xsl zip

#RUN if [ ${PHP_VERSION} = "7.4"]; then \
#    	docker-php-ext-enable xmlrpc; \
#        apk imagemagick; \
#    	pecl install -o -f imagick; \
#    	docker-php-ext-enable imagic; \
#    elif [ ${PHP_VERSION} = "8.0" ]; then \
#    	apk xmlrpc-1.0.0RC3; \
#    	docker-php-ext-enable xmlrpc; \
#        apk imagemagick; \
#    	pecl install -o -f imagick; \
#    	docker-php-ext-enable imagic; \
#    fi

# CLEAN UP PACKAGES AND APK CACHE
RUN rm -rf /var/cache/apk/*
# RUN apk del _build_deps_

# INSTALL COMPOSER
RUN curl -s https://getcomposer.org/installer | php \
	&& mv composer.phar /bin/composer.phar \
	&& alias composer='php /bin/composer.phar'

# INSTALL NPM
RUN apk add --update nodejs npm

# INSTALL libreoffice and fonts
#RUN apk update && apk add libreoffice
#RUN apk add --no-cache msttcorefonts-installer fontconfig
#RUN update-ms-fonts

# Google fonts
#RUN wget https://github.com/google/fonts/archive/main.tar.gz -O gf.tar.gz --no-check-certificate
#RUN tar -xf gf.tar.gz
#RUN mkdir -p /usr/share/fonts/truetype/google-fonts
#RUN find $PWD/fonts-main/ -name "*.ttf" -exec install -m644 {} /usr/share/fonts/truetype/google-fonts/ \; || return 1
#RUN rm -f gf.tar.gz
#RUN fc-cache -f && rm -rf /var/cache/*

# INSTALL NGINX
RUN apk add nginx
RUN rm -f /etc/nginx/http.d/default.conf

# CREATE CODE DIRECTORY
RUN mkdir -p /var/www/html
RUN chown laravel:laravel /var/www/html


############################## dev ##############################
FROM base_image AS dev

ARG ENV
RUN echo $ENV

# CONFIGURE PHP
ADD ./envs/${ENV}/php/www.conf /usr/local/etc/php-fpm.d/www.conf
ADD ./envs/${ENV}/php/php.ini /usr/local/etc/php/php.ini
ADD ./envs/${ENV}/php/ldap.conf /etc/openldap/ldap.conf
ADD ./envs/${ENV}/cron/crontab /etc/crontabs/root

# CONFIGURE NGINX
ARG APP_DOMAIN
ADD ./envs/${ENV}/nginx/web_site.conf /etc/nginx/http.d/web_site.conf
RUN mkdir -p /etc/nginx/certs
ADD ./envs/${ENV}/nginx/certs/ /etc/nginx/certs/
RUN cd /etc/nginx/certs && chmod +x create-ca.sh && ./create-ca.sh && chmod +x create-certificate.sh && ./create-certificate.sh "${APP_DOMAIN}"
RUN rm -rf /etc/nginx/certs.app.* && \
    cp /etc/nginx/certs/${APP_DOMAIN}.crt /etc/nginx/certs/app.crt && \
    cp /etc/nginx/certs/${APP_DOMAIN}.key /etc/nginx/certs/app.key

# Override stop signal to stop process gracefully
# https://github.com/php/php-src/blob/17baa87faddc2550def3ae7314236826bc1b1398/sapi/fpm/php-fpm.8.in#L163
STOPSIGNAL SIGQUIT

# CONFIGURE SUPEVISORD
COPY ./envs/${ENV}/supervisord/supervisord.conf /etc/supervisord.conf
CMD ["supervisord", "-c", "/etc/supervisord.conf"]


############################## prod ##############################
FROM base_image AS prod

ARG ENV
RUN echo $ENV
ARG CODE_REPO_URL
ARG APP_DOMAIN

RUN apk add git

# CONFIGURE PHP
ADD ./envs/${ENV}/php/www.conf /usr/local/etc/php-fpm.d/www.conf
ADD ./envs/${ENV}/php/php.ini /usr/local/etc/php/php.ini
ADD ./envs/${ENV}/php/ldap.conf /etc/openldap/ldap.conf
ADD ./envs/${ENV}/cron/crontab /etc/crontabs/root

# CODE
ARG CACHE_DATE=break_the_cache
RUN echo ${CACHE_DATE}
RUN rm -rf /var/www/html
RUN mkdir -p /var/www/html
RUN git clone ${CODE_REPO_URL} /var/www/html
COPY ./envs/${ENV}/laravel/.env /var/www/html/.env
RUN chown -R laravel:laravel /var/www

# BUILD THE CODE
WORKDIR /var/www/html
USER laravel
RUN php /bin/composer.phar install
RUN npm install
RUN npm run build
USER root

# CONFIGURE NGINX
ADD ./envs/${ENV}/nginx/web_site.conf /etc/nginx/http.d/web_site.conf
RUN mkdir -p /etc/nginx/certs
ADD ./envs/${ENV}/nginx/certs/ /etc/nginx/certs/
RUN cd /etc/nginx/certs && chmod +x create-ca.sh && ./create-ca.sh && chmod +x create-certificate.sh && ./create-certificate.sh "${APP_DOMAIN}"
RUN rm -rf /etc/nginx/certs.app.* && \
    cp /etc/nginx/certs/${APP_DOMAIN}.crt /etc/nginx/certs/app.crt && \
    cp /etc/nginx/certs/${APP_DOMAIN}.key /etc/nginx/certs/app.key

# Override stop signal to stop process gracefully
# https://github.com/php/php-src/blob/17baa87faddc2550def3ae7314236826bc1b1398/sapi/fpm/php-fpm.8.in#L163
STOPSIGNAL SIGQUIT

# CONFIGURE SUPEVISORD
COPY ./envs/${ENV}/supervisord/supervisord.conf /etc/supervisord.conf
CMD ["supervisord", "-c", "/etc/supervisord.conf"]