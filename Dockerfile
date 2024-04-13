# Use the official Ubuntu 18.04 LTS base image
FROM ubuntu:20.04

# Install Apache, PHP, and necessary PHP extensions along with MariaDB
RUN apt-get update && apt-get install -y \
    apache2 \
    php7.2 \
    php7.2-mysql \
    php7.2-mbstring \
    php7.2-xml \
    php7.2-gd \
    php7.2-curl \
    php7.2-ldap \
    php7.2-zip \
    libapache2-mod-php7.2 \
    mariadb-server \
    mariadb-client \
    wget \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && a2enmod rewrite

# Download and install Sentrifugo
WORKDIR /tmp
RUN wget http://www.sentrifugo.com/home/downloadfile?file_name=Sentrifugo.zip -O Sentrifugo.zip \
    && unzip Sentrifugo.zip -d /var/www/html/ \
    && mv /var/www/html/Sentrifugo_3.2 /var/www/html/sentrifugo \
    && chown -R www-data:www-data /var/www/html/sentrifugo \
    && chmod -R 755 /var/www/html/sentrifugo

# Configure Apache
COPY sentrifugo.conf /etc/apache2/sites-available/sentrifugo.conf
RUN a2ensite sentrifugo

# Expose port 80
EXPOSE 80

# Use a custom script to start MariaDB and Apache
COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh

CMD ["/usr/local/bin/start.sh"]
