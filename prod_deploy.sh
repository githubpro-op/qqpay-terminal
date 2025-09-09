#!/usr/bin/env bash
set -euo pipefail
export DEBIAN_FRONTEND=noninteractive

APP_DIR="/var/www/qqpay"
DOMAIN="qqpays.online"
DB_NAME="qqpay"
DB_USER="qqpay"
DB_PASS="Atlast786@"

echo "=== Step 1: Update system ==="
apt update -y
apt upgrade -y

echo "=== Step 2: Install packages ==="
apt install -y software-properties-common curl git unzip \
    nginx mysql-server php8.2 php8.2-cli php8.2-fpm \
    php8.2-mysql php8.2-xml php8.2-mbstring php8.2-curl php8.2-zip composer

systemctl enable --now nginx
systemctl enable --now mysql
systemctl enable --now php8.2-fpm

echo "=== Step 3: Configure MySQL ==="
mysql -u root <<SQL || true
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASS}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'localhost';
FLUSH PRIVILEGES;
SQL

echo "=== Step 4: Install Laravel ==="
if [ ! -f "${APP_DIR}/artisan" ]; then
  rm -rf "${APP_DIR}"
  composer create-project laravel/laravel "${APP_DIR}" "10.*"
fi

echo "=== Step 5: Configure Laravel .env ==="
cd "${APP_DIR}"
cp -n .env.example .env
sed -i "s|APP_URL=.*|APP_URL=https://${DOMAIN}|" .env
sed -i "s|DB_DATABASE=.*|DB_DATABASE=${DB_NAME}|" .env
sed -i "s|DB_USERNAME=.*|DB_USERNAME=${DB_USER}|" .env
sed -i "s|DB_PASSWORD=.*|DB_PASSWORD=${DB_PASS}|" .env

php artisan key:generate --force
php artisan migrate --force || true

echo "=== Step 6: Nginx config ==="
NGX="/etc/nginx/sites-available/${DOMAIN}"
cat > "${NGX}" <<NGINX
server {
    listen 80;
    server_name ${DOMAIN} www.${DOMAIN};
    root ${APP_DIR}/public;
    index index.php index.html;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php\$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/run/php/php8.2-fpm.sock;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }
}
NGINX

ln -sf "${NGX}" /etc/nginx/sites-enabled/${DOMAIN}
nginx -t && systemctl reload nginx

echo "=== Step 7: Permissions ==="
chown -R www-data:www-data "${APP_DIR}"
chmod -R 775 "${APP_DIR}/storage" "${APP_DIR}/bootstrap/cache"

echo "=== Step 8: SSL Setup (Let's Encrypt) ==="
apt install -y certbot python3-certbot-nginx
certbot --nginx -d ${DOMAIN} -d www.${DOMAIN} -m tio@${DOMAIN} --agree-tos --non-interactive || true

echo "=== Deployment complete ==="
echo "Open: https://${DOMAIN}"
