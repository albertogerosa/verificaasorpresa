#!/bin/bash

echo "🚀 Avvio Progetto Verificaasorpresa"
echo "===================================="
echo ""

# 1. Avvia MySQL con Docker
echo "📦 Avvio MySQL con Docker..."
docker-compose up -d

echo ""
echo "⏳ Attendo che MySQL sia pronto..."
sleep 10

# 2. Verifica connessione
echo ""
echo "🔍 Verifico connessione al database..."
docker exec forniture_db mysql -uroot -proot -e "SHOW DATABASES;" | grep Forniture

if [ $? -eq 0 ]; then
    echo "✅ Database Forniture pronto!"
else
    echo "⚠️  Attendo ancora..."
    sleep 5
fi

# 3. Avvia il server PHP
echo ""
echo "🌐 Avvio server PHP su http://localhost:8000"
echo ""
echo "======================================"
echo "📋 Endpoints disponibili:"
echo "   http://localhost:8000              (lista endpoints)"
echo "   http://localhost:8000/api/pezzi-forniti"
echo "   http://localhost:8000/api/fornitori-tutti-pezzi"
echo "======================================"
echo ""
echo "Premi CTRL+C per fermare il server"
echo ""

php -S localhost:8000 -t public
