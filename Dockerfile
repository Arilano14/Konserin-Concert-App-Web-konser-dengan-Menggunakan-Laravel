# Gunakan image PHP official dengan Apache
FROM php:8.1-apache

# Install sistem dependency yang dibutuhkan Laravel
RUN apt-get update && apt-get install -y \
    libonig-dev \
    libzip-dev \
    zip \
    unzip \
    git \
    curl

# Install ekstensi PHP untuk Laravel
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl bcmath

# Aktifkan mod_rewrite Apache (penting untuk routing Laravel)
RUN a2enmod rewrite

# Copy semua kode ke dalam container
COPY . /var/www/html/

# Set direktori kerja
WORKDIR /var/www/html/

# Install Composer (pakai official composer image sebagai sumber)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install dependencies PHP Laravel
RUN composer install --no-dev --optimize-autoloader

# Generate APP_KEY Laravel (bisa juga lewat env, ini opsional)
RUN php artisan key:generate

# Set permission agar storage dan cache bisa ditulis
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Buka port 80 (Apache)
EXPOSE 80

# Jalankan Apache
CMD ["apache2-foreground"]
