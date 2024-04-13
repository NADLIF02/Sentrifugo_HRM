# Use the official Ubuntu 20.04 LTS base image
FROM ubuntu:20.04

# Prevent tzdata from prompting for time zone
ENV DEBIAN_FRONTEND=noninteractive

# Setup the environment
RUN apt-get update -y && \
    apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:ondrej/php && \
    apt-get update -y && \
    apt-get install -y \
        php7.2 \
        libapache2-mod-php7.2 \
        php7.2-common \
        php7.2-mbstring \
        php7.2-xmlrpc \
        php7.2-soap \
        php7.2-gd \
        php7.2-xml \
        php7.2-intl \
        php7.2-mysql \
        php7.2-cli \
        php7.2-ldap \
        php7.2-zip \
        php7.2-curl \
        apache2 \
        mariadb-server \
        mariadb-client \
        wget \
        unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    a2enmod rewrite

# Download PHPUnit
RUN wget -O phpunit https://phar.phpunit.de/phpunit-8.phar && \
    chmod +x phpunit && \
    mv phpunit /usr/local/bin/phpunit

# Download and install Sentrifugo
WORKDIR /tmp
RUN wget http://www.sentrifugo.com/home/downloadfile?file_name=Sentrifugo.zip -O Sentrifugo.zip \
    && unzip Sentrifugo.zip -d /var/www/html/ \
    && mv /var/www/html/Sentrifugo_3.2 /var/www/html/sentrifugo \
    && chown -R www-data:www-data /var/www/html/sentrifugo \
    && chmod -R 755 /var/www/html/sentrifugo

# Configure Apache
COPY sentrifugo.conf /etc/apache2/sites-available/sentrifugo.conf
RUN a2ensite sentrifugo && \
    service apache2 restart

# Expose port 80
EXPOSE 80

# Start Apache and MariaDB in the foreground
CMD service mariadb start && apache2ctl -D FOREGROUND
