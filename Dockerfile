FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    apache2=2.4.41* \
    php \
    libapache2-mod-php \
    php-mysql \
    php-pdo \
    php-xml \
    unzip \
    && apt-get clean

COPY html.zip /tmp/html.zip
RUN unzip /tmp/html.zip -d /tmp/ \
    && cp -r /tmp/html/. /var/www/html/ \
    && rm -rf /tmp/html.zip /tmp/html

RUN a2enmod php* rewrite 2>/dev/null || true

# Fix DB host to point to MySQL service and fix permissions
RUN sed -i "s/host=localhost/host=db/" /var/www/html/project/core/config/databases.yml \
    && chown -R www-data:www-data /var/www/html/project/core/log /var/www/html/project/core/cache \
    && chmod -R 775 /var/www/html/project/core/log /var/www/html/project/core/cache

EXPOSE 80

CMD ["apache2ctl", "-D", "FOREGROUND"]
