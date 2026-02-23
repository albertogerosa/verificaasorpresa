#!/bin/bash

# Script di setup per il progetto verificaasorpresa

echo "=== Setup Database Forniture ==="
echo ""

# Chiedi le credenziali MySQL
read -p "MySQL Host [localhost]: " DB_HOST
DB_HOST=${DB_HOST:-localhost}

read -p "MySQL User [root]: " DB_USER
DB_USER=${DB_USER:-root}

read -sp "MySQL Password: " DB_PASS
echo ""

read -p "Database Name [Forniture]: " DB_NAME
DB_NAME=${DB_NAME:-Forniture}

# Crea file .env
echo "Creazione file .env..."
cat > .env << EOF
DB_HOST=$DB_HOST
DB_NAME=$DB_NAME
DB_USER=$DB_USER
DB_PASS=$DB_PASS
EOF

echo "✓ File .env creato"

# Importa il database
echo ""
echo "Importazione database..."
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASS" < database.sql

if [ $? -eq 0 ]; then
    echo "✓ Database importato con successo"
else
    echo "✗ Errore durante l'importazione del database"
    exit 1
fi

echo ""
echo "=== Setup completato! ==="
echo ""
echo "Per avviare il server di sviluppo:"
echo "  php -S localhost:8000 -t public"
echo ""
echo "Quindi apri nel browser:"
echo "  http://localhost:8000"
echo ""
