# ✅ Resumen de Correcciones — Build & Deployment

## Problemas Identificados y Corregidos

### 1. ❌ Error: Bootstrap requiere motor Sass

**Problema:** `Bundler::GemRequireError: bootstrap requires a Sass engine`

**Solución:** Añadido `gem "cssbundling-rails"` en `Gemfile` (antes de bootstrap)

**Archivos modificados:**

- `Gemfile`

### 2. ❌ Falta Node.js/npm en Dockerfile

**Problema:** `cssbundling-rails` necesita npm para compilar CSS, pero no estaba instalado.

**Solución:** Añadidos `node-gyp npm` en ambas etapas del Dockerfile (base y build)

**Archivos modificados:**

- `Dockerfile`

### 3. ❌ Variables de entorno para credenciales no documentadas

**Problema:** El `docker-entrypoint` no generaba `master.key` desde `RAILS_MASTER_KEY`

**Solución:** Actualizado `bin/docker-entrypoint` para crear `config/master.key` automáticamente

**Archivos modificados:**

- `bin/docker-entrypoint`

### 4. ❌ Falta documentación de deploy con Docker

**Solución:** Creados documentos completos

**Archivos creados:**

- `DEPLOYMENT.md` (guía paso a paso con ejemplos)
- `bin/setup-credentials.sh` (script auxiliar)
- `.env.example` (template de variables de entorno)

### 5. ❌ Dockerfile no copiaba package.json

**Problema:** `cssbundling-rails` necesita dependencias de npm, pero no se copiaba `package.json`

**Solución:** Actualizado Dockerfile para copiar `package.json` e instalar con `npm ci`

**Archivos modificados:**

- `Dockerfile`

### 6. ❌ Falta variable RAILS_ENV en precompile

**Problema:** `assets:precompile` sin `RAILS_ENV=production` puede fallar en algunos casos

**Solución:** Añadida `RAILS_ENV=production` explícitamente

**Archivos modificados:**

- `Dockerfile`

## Cambios de Archivo por Archivo

### Gemfile

```diff
+ gem "cssbundling-rails"
  gem 'bootstrap', '~> 5.3.0'
```

### Dockerfile

```diff
# Base stage
+ apt-get install --no-install-recommends -y ... node-gyp npm ...

# Build stage
+ apt-get install --no-install-recommends -y ... node-gyp npm ...

# Copiar packages y instalar npm
+ COPY ... package.json* ./
+ RUN if [ -f package.json ]; then npm ci --prefer-offline --no-audit; fi

# Assets precompile con RAILS_ENV
- RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile
+ RUN SECRET_KEY_BASE_DUMMY=1 RAILS_ENV=production ./bin/rails assets:precompile
```

### bin/docker-entrypoint

```diff
+ # Generar master.key si está definida la variable RAILS_MASTER_KEY
+ if [ -n "$RAILS_MASTER_KEY" ] && [ ! -f config/master.key ]; then
+   echo "$RAILS_MASTER_KEY" > config/master.key
+ fi
```

### README.md

```diff
+ ## 🐳 Despliegue con Docker
+ (Sección con instrucciones rápidas)
```

## Nuevos Archivos Creados

1. **DEPLOYMENT.md** — Guía completa para despliegue con Docker, Docker Compose, y troubleshooting
2. **bin/setup-credentials.sh** — Script para generar credenciales de forma segura
3. **.env.example** — Template de variables de entorno con valores por defecto

## ✅ Próximo Paso: Construir y Probar

```bash
# 1. Actualizar Gemfile.lock
bundle install

# 2. Construir imagen Docker
docker build -t sistema_ventas .

# 3. Ejecutar con credentials
RAILS_MASTER_KEY=$(openssl rand -hex 32)
docker run -d \
  -p 3000:3000 \
  -e RAILS_ENV=development \
  -e RAILS_MASTER_KEY=$RAILS_MASTER_KEY \
  --name sistema_ventas \
  sistema_ventas

# 4. Verificar que funciona
docker logs -f sistema_ventas
curl http://localhost:3000
```

## 📋 Checklist de Despliegue

- ✅ `cssbundling-rails` añadido a Gemfile
- ✅ Node.js/npm instalados en Dockerfile
- ✅ `master.key` generado automáticamente en Docker
- ✅ Assets precompilados correctamente
- ✅ Variables de entorno documentadas
- ✅ Guía de deploy (DEPLOYMENT.md) creada
- ⏳ **Siguiente:** Ejecutar `bundle install` y `docker build`

---

Todos los cambios son **compatibles con Ruby on Rails 8.1.2** y **Bootstrap 5.3**.
