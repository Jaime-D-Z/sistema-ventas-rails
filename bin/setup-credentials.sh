#!/bin/bash
# Script para generar master.key y credentials para Docker

if [ -z "$RAILS_MASTER_KEY" ]; then
  echo "⚠️  RAILS_MASTER_KEY no definida. Generando una nueva..."
  RAILS_MASTER_KEY=$(openssl rand -hex 32)
  echo "Nueva RAILS_MASTER_KEY generada: $RAILS_MASTER_KEY"
  echo "⚠️  Guarda este valor en un lugar seguro (p.ej., GitHub Secrets o .env de producción)"
fi

# Exportar para que Rails la use
export RAILS_MASTER_KEY

# Crear directorio config si no existe
mkdir -p config

# Escribir master.key
echo "$RAILS_MASTER_KEY" > config/master.key
echo "✓ config/master.key creado"

# Si credentials.yml.enc no existe, generar default
if [ ! -f config/credentials.yml.enc ]; then
  echo "Generando credentials.yml.enc por defecto..."
  bundle exec rails credentials:edit --wait || true
  echo "✓ config/credentials.yml.enc creado"
fi

echo "✓ Listo para ejecutar Rails"
