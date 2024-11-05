# Usar la imagen de PHP 7.1 con Apache
FROM php:7.1-fpm

# Instalar dependencias del sistema
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    zip \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql zip  # Importante: incluir zip aquí

# Habilitar módulos de Apache
#RUN a2enmod rewrite
# Establecer el directorio de trabajo
WORKDIR /var/www

# Copiar los archivos de la aplicación
COPY . .

# Instalar dependencias de Composer
RUN composer update --no-dev --optimize-autoloader

# Copiar el archivo de configuración de PHP
COPY .docker/php/php.ini /usr/local/etc/php/php.ini

# Establecer permisos correctos
RUN chown -R www-data:www-data /var/www \
    && chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Exponer el puerto
EXPOSE 9000

# Exponer el puerto 9000 y ejecutar PHP-FPM
EXPOSE 9000
CMD ["php-fpm"]

RUN composer install --optimize-autoloader --no-dev
