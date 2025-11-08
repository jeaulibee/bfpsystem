# Use the official PHP image with necessary extensions
FROM php:8.2-apache

# Enable Apache mod_rewrite for Laravel
RUN a2enmod rewrite

# Install dependencies
RUN apt-get update && apt-get install -y \
    git curl libpq-dev unzip libzip-dev nodejs npm \
    && docker-php-ext-install pdo pdo_pgsql zip

# Copy existing application files
COPY . /var/www/html

# Set working directory
WORKDIR /var/www/html

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Build frontend assets with Vite
RUN npm install && npm run build

# Set proper permissions
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Expose port 10000
EXPOSE 10000

# Start Apache
CMD ["apache2-foreground"]
