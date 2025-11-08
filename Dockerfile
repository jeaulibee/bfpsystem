# Use official PHP 8.2 image with Apache
FROM php:8.2-apache

# -----------------------
# 1. Install system dependencies
# -----------------------
RUN apt-get update && apt-get install -y \
    git zip unzip libpng-dev libjpeg-dev libfreetype6-dev libonig-dev libxml2-dev libpq-dev curl npm nodejs \
    && docker-php-ext-install pdo pdo_pgsql mbstring exif pcntl bcmath gd \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# -----------------------
# 2. Enable Apache mod_rewrite
# -----------------------
RUN a2enmod rewrite

# Suppress Apache ServerName warning
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# -----------------------
# 3. Copy project files
# -----------------------
COPY . /var/www/html

# Set working directory
WORKDIR /var/www/html

# -----------------------
# 4. Set Apache document root to Laravel's public folder
# -----------------------
RUN sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|' /etc/apache2/sites-available/000-default.conf

# -----------------------
# 5. Install Composer
# -----------------------
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# -----------------------
# 6. Install PHP dependencies
# -----------------------
RUN composer install --no-dev --optimize-autoloader

# -----------------------
# 7. Build frontend assets (Vite)
# -----------------------
RUN npm install && npm run build

# -----------------------
# 8. Set correct file permissions
# -----------------------
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# -----------------------
# 9. Expose port (Render will map automatically)
# -----------------------
EXPOSE 10000

# -----------------------
# 10. Clear caches and run migrations safely, then start Apache
# -----------------------
CMD php artisan config:clear && \
    php artisan route:clear && \
    php artisan view:clear && \
    php artisan migrate --force --quiet || true && \
    apache2-foreground
