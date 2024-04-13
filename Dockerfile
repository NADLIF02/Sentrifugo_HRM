FROM ubuntu:20.2

# Install Apache, PHP, MariaDB, and other necessary packages
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
    unzip \
    wget \
    mariadb-server \
    mariadb-client \
    && a2enmod rewrite \
    && service mysql start \
    && mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION; FLUSH PRIVILEGES;" 

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

# Start Apache2 and MariaDB in the foreground
CMD service mysql start && apache2ctl -D FOREGROUND
