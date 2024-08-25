ARG NGINX_VERSION

FROM nginx:${NGINX_VERSION}-alpine

ARG APP_DOMAIN

RUN apk add openssl

RUN rm /etc/nginx/conf.d/default.conf

ADD ./nginx/web_site.conf /etc/nginx/conf.d/web_site.conf

RUN mkdir -p /var/www/html

RUN mkdir -p /etc/nginx/certs

ADD ./nginx/certs/ /etc/nginx/certs/

RUN cd /etc/nginx/certs && chmod +x create-ca.sh && ./create-ca.sh && chmod +x create-certificate.sh && ./create-certificate.sh "${APP_DOMAIN}"

RUN rm -rf /etc/nginx/certs.app.* && \
    cp /etc/nginx/certs/${APP_DOMAIN}.crt /etc/nginx/certs/app.crt && \
    cp /etc/nginx/certs/${APP_DOMAIN}.key /etc/nginx/certs/app.key
