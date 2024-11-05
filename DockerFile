# Usar la imagen de PHP 7.1 con Apache
FROM php:7.1-apache

# Instalar extensiones necesarias para Laravel
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    zip \
    unzip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd \
    && docker-php-ext-install pdo pdo_mysql zip

# Habilitar módulos de Apache
#RUN a2enmod rewrite

# Configurar el directorio de trabajo
WORKDIR /var/www/html

# Copiar los archivos de la aplicación
COPY . /var/www/html

# Instalar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Dar permisos al directorio de almacenamiento
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Configuración de permisos
RUN chmod -R 775 /var/www/storage /var/www/bootstrap/cache
# Instalar dependencias de Composer
RUN composer install --optimize-autoloader --no-dev

# Exponer el puerto 80
EXPOSE 9000

CMD ["php-fpm"]
