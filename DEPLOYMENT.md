# 🚀 Guía de Despliegue — Sistema de Ventas

## Despliegue con Docker

### 1. Generar RAILS_MASTER_KEY (primera vez)

```bash
# Genera una nueva clave maestra (solo necesario una vez)
openssl rand -hex 32
# Ejemplo: a1b2c3d4e5f6g7h8i9j0k1l2m3n4o5p6q7r8s9t0u1v2w3x4y5z6a7b8c9d0
```

Guarda este valor en un lugar seguro (variables de entorno de producción, GitHub Secrets, etc.).

### 2. Construir imagen Docker

```bash
docker build -t sistema_ventas .
```

### 3. Ejecutar contenedor

**En desarrollo (con volumen):**

```bash
docker run -d \
  -p 3000:3000 \
  -e RAILS_ENV=development \
  -e RAILS_MASTER_KEY=tu_clave_generada \
  -v $(pwd):/rails \
  --name sistema_ventas_dev \
  sistema_ventas
```

**En producción:**

```bash
docker run -d \
  -p 80:80 \
  -e RAILS_ENV=production \
  -e RAILS_MASTER_KEY=tu_clave_generada \
  -e DATABASE_URL=sqlite3:db/production.sqlite3 \
  --name sistema_ventas_prod \
  sistema_ventas
```

### 4. Acceder a logs y consola

```bash
# Ver logs en tiempo real
docker logs -f sistema_ventas_prod

# Entrar a consola Rails en el contenedor
docker exec -it sistema_ventas_prod bin/rails console
```

## Troubleshooting

### Error: "Bundler::GemRequireError: bootstrap requires Sass engine"

**Solución:** Verificar que `cssbundling-rails` esté en `Gemfile` (añadida en corrección anterior).

### Error: "RAILS_MASTER_KEY not set"

**Solución:** Pasar `-e RAILS_MASTER_KEY=valor` al ejecutar `docker run`.

### Contenedor se reinicia constantemente

**Solución:** Revisar logs con `docker logs nombre_contenedor` para identificar el error real.

## Persistencia de Datos

### Usar volumen para base de datos SQLite:

```bash
docker volume create sistema_ventas_db

docker run -d \
  -p 80:80 \
  -e RAILS_ENV=production \
  -e RAILS_MASTER_KEY=tu_clave \
  -v sistema_ventas_db:/rails/db \
  --name sistema_ventas \
  sistema_ventas
```

### Cambiar a PostgreSQL (recomendado para producción):

1. Actualizar `Gemfile`: reemplazar `gem 'sqlite3'` con `gem 'pg'`
2. Actualizar `config/database.yml` si es necesario
3. Pasar `DATABASE_URL` en Docker:

```bash
docker run -d \
  -e DATABASE_URL=postgresql://user:pass@host:5432/db_name \
  ...
```

## Con Docker Compose

Crear `docker-compose.yml` (opcional):

```yaml
version: "3.8"

services:
  web:
    build: .
    ports:
      - "80:80"
    environment:
      RAILS_ENV: production
      RAILS_MASTER_KEY: ${RAILS_MASTER_KEY}
      DATABASE_URL: sqlite3:db/production.sqlite3
    volumes:
      - ./db:/rails/db
    restart: unless-stopped
```

Ejecutar:

```bash
RAILS_MASTER_KEY=tu_clave docker-compose up -d
```

---

Para más detalles, ver [README.md](README.md).
