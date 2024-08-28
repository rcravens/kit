############################## base_image ##############################
ARG PYTHON_VERSION
FROM python:${PYTHON_VERSION} AS base_image

ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt-get update

RUN apt-get install -y libgdal-dev supervisor

RUN pip install --upgrade pip

RUN pip install gunicorn psycopg2-binary GDAL==3.2.2.1 redis Django django-environ django-redis-sessions

# INSTALL NGINX
RUN apt install nginx openssl
RUN rm -f /etc/nginx/http.d/default.conf

# CREATE CODE DIRECTORY
RUN mkdir -p /app/code

# COPY start script for PYTHON
ADD .python/start.sh /usr/local/bin

############################## dev ##############################
FROM base_image AS dev

ARG APP_DOMAIN

# CONFIGURE NGINX
ADD ./nginx/web_site.conf /etc/nginx/conf.d/web_site.conf
RUN mkdir -p /etc/nginx/certs
ADD ./nginx/certs/ /etc/nginx/certs/
RUN cd /etc/nginx/certs && ./create-ca.sh && ./create-certificate.sh "${APP_DOMAIN}"
RUN rm -rf /etc/nginx/certs.app.* && \
    cp /etc/nginx/certs/${APP_DOMAIN}.crt /etc/nginx/certs/app.crt && \
    cp /etc/nginx/certs/${APP_DOMAIN}.key /etc/nginx/certs/app.key


# Override stop signal to stop process gracefully
# https://github.com/php/php-src/blob/17baa87faddc2550def3ae7314236826bc1b1398/sapi/fpm/php-fpm.8.in#L163
STOPSIGNAL SIGQUIT

# CONFIGURE SUPEVISORD
COPY ./supervisord/supervisord-dev.conf /etc/supervisord.conf
CMD ["supervisord", "-c", "/etc/supervisord.conf"]


############################### stage ##############################
#FROM base_image AS stage
#
#ARG CODE_REPO_URL
#ARG APP_DOMAIN
#
#RUN apk add git
#
## CONFIGURE PHP
#ADD ./php/www.conf /usr/local/etc/php-fpm.d/www.conf
#ADD ./php/php.ini /usr/local/etc/php/php.ini
#ADD ./php/ldap.conf /etc/openldap/ldap.conf
#ADD ./php/crontab /etc/crontabs/root
#
## CODE
#RUN rm -rf /var/www/html
#RUN mkdir -p /var/www/html
#RUN git clone ${CODE_REPO_URL} /var/www/html
#COPY ./laravel/.env.stage /var/www/html/.env
#RUN chown -R laravel:laravel /var/www
#
## BUILD THE CODE
#WORKDIR /var/www/html
#USER laravel
#RUN php /bin/composer.phar install
#RUN php artisan key:generate
#RUN npm install
#RUN npm run build
#USER root
#
## CONFIGURE NGINX
#ADD ./nginx/web_site.conf /etc/nginx/http.d/web_site.conf
#RUN mkdir -p /etc/nginx/certs
#ADD ./nginx/certs/ /etc/nginx/certs/
#RUN cd /etc/nginx/certs && chmod +x create-ca.sh && ./create-ca.sh && chmod +x create-certificate.sh && ./create-certificate.sh "${APP_DOMAIN}"
#RUN rm -rf /etc/nginx/certs.app.* && \
#    cp /etc/nginx/certs/${APP_DOMAIN}.crt /etc/nginx/certs/app.crt && \
#    cp /etc/nginx/certs/${APP_DOMAIN}.key /etc/nginx/certs/app.key
#
## Override stop signal to stop process gracefully
## https://github.com/php/php-src/blob/17baa87faddc2550def3ae7314236826bc1b1398/sapi/fpm/php-fpm.8.in#L163
#STOPSIGNAL SIGQUIT
#
## CONFIGURE SUPEVISORD
#COPY ./supervisord/supervisord-dev.conf /etc/supervisord.conf
#CMD ["supervisord", "-c", "/etc/supervisord.conf"]
#
#
############################### prod ##############################
#FROM base_image AS prod
#
#ARG CODE_REPO_URL
#ARG APP_DOMAIN
#
#RUN apk add git
#
## CONFIGURE PHP
#ADD ./php/www.conf /usr/local/etc/php-fpm.d/www.conf
#ADD ./php/php.ini /usr/local/etc/php/php.ini
#ADD ./php/ldap.conf /etc/openldap/ldap.conf
#ADD ./php/crontab /etc/crontabs/root
#
## CODE
#RUN rm -rf /var/www/html
#RUN mkdir -p /var/www/html
#RUN git clone ${CODE_REPO_URL} /var/www/html
#COPY ./laravel/.env.prod /var/www/html/.env
#RUN chown -R laravel:laravel /var/www
#
## BUILD THE CODE
#WORKDIR /var/www/html
#USER laravel
#RUN php /bin/composer.phar install
#RUN php artisan key:generate
#RUN npm install
#RUN npm run build
#USER root
#
## CONFIGURE NGINX
#ADD ./nginx/web_site.conf /etc/nginx/http.d/web_site.conf
#RUN mkdir -p /etc/nginx/certs
#ADD ./nginx/certs/ /etc/nginx/certs/
#RUN cd /etc/nginx/certs && chmod +x create-ca.sh && ./create-ca.sh && chmod +x create-certificate.sh && ./create-certificate.sh "${APP_DOMAIN}"
#RUN rm -rf /etc/nginx/certs.app.* && \
#    cp /etc/nginx/certs/${APP_DOMAIN}.crt /etc/nginx/certs/app.crt && \
#    cp /etc/nginx/certs/${APP_DOMAIN}.key /etc/nginx/certs/app.key
#
## Override stop signal to stop process gracefully
## https://github.com/php/php-src/blob/17baa87faddc2550def3ae7314236826bc1b1398/sapi/fpm/php-fpm.8.in#L163
#STOPSIGNAL SIGQUIT
#
## CONFIGURE SUPEVISORD
#COPY ./supervisord/supervisord-dev.conf /etc/supervisord.conf
#CMD ["supervisord", "-c", "/etc/supervisord.conf"]