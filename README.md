# 📦 Sistema de Ventas

Breve y simple sistema de ventas construido con Ruby on Rails para gestionar productos, registrar ventas y llevar control del stock por usuario.

---

## 📌 Nombre y propósito

- **Nombre:** Sistema de Ventas
- **Propósito:** Proveer una aplicación web para gestionar un catálogo de productos, permitir a usuarios autenticados crear ventas (registrar productos vendidos, ajustar stock) y consultar un dashboard con métricas básicas.

## 🚀 Características principales

- Autenticación de usuarios mediante Devise (registro, login, recuperación de contraseña).
- CRUD completo de `Producto` (crear, listar, editar, eliminar).
- Registro de `Venta` por usuario: selección de productos con cantidades, cálculo de totales y ajuste automático de stock.
- Dashboard con totales y ventas recientes por usuario autenticado.
- APIs JSON mínimas en `ProductosController` (create/index/show) además de vistas HTML.

## 🧱 Tecnologías usadas

- Lenguaje: Ruby 3.x compatible con Rails 8.1.x
- Framework: Ruby on Rails ~> 8.1.2
- Base de datos por defecto: SQLite3 (desarrollo)
- Autenticación: Devise
- Frontend: Bootstrap 5 (gem `bootstrap`), Hotwire (Turbo, Stimulus)
- Asset pipeline: Propshaft, Importmap
- Otras gems: `jbuilder`, `image_processing`, `cssbundling-rails` y utilidades de desarrollo (`bootsnap`, `brakeman`, `bundler-audit`).

## 📁 Estructura del proyecto (resumen)

- `app/controllers/` — controladores principales:
  - `home_controller.rb` — `index`, `dashboard`
  - `productos_controller.rb` — CRUD de productos (HTML + JSON para `create`/`show`)
  - `ventas_controller.rb` — `index`, `new`, `create`, `show` (registro de ventas y ajuste de stock)
- `app/models/` — modelos principales:
  - `producto.rb` — entidad `Producto` (atributos: `nombre`, `precio`, `stock`, `descripcion`)
  - `venta.rb` — entidad `Venta` (pertenece a `User`, tiene `detalle_ventas`, valida `total` y setea `fecha` antes de crear)
  - `detalle_venta.rb` — detalle por producto en cada venta (cantidad, subtotal)
  - `user.rb` — modelo de usuario con Devise y relación `has_many :ventas`
- `config/routes.rb` — rutas principales:
  - `devise_for :users`
  - `root 'home#index'`
  - `resources :productos`
  - `resources :ventas, only: [:index, :new, :create, :show]`
  - `get 'dashboard', to: 'home#dashboard'`
- `db/migrate/` — migraciones para usuarios, productos, ventas y detalles.
- `db/` — `schema.rb` y `seeds.rb` (semillas si aplica).

## ⚙️ Requisitos previos

- Ruby compatible con Rails 8.1 (usa la versión que tengas configurada; recomendamos Ruby 3.2+).
- Bundler (`gem install bundler`).
- SQLite3 (para entorno de desarrollo por defecto).
- Node.js y npm/yarn solo si vas a usar herramientas de empaquetado adicionales (aunque el proyecto usa importmap/propshaft).

## 🔧 Instalación (paso a paso)

1. Clona el repositorio:

```bash
git clone <repositorio.git>
cd sistema_ventas
```

Otras gems: `jbuilder`, `image_processing`, `sassc-rails` y utilidades de desarrollo (`bootsnap`, `brakeman`, `bundler-audit`). 3. Instala dependencias de JS/CSS si aplicara (opcional):

```bash
# Si el proyecto usa cssbundling con npm/Esbuild u otra herramienta
# revisar `package.json` y la configuración; por defecto no es necesario con importmap
```

4. Prepara la base de datos y carga migraciones:

```bash
bin/rails db:create db:migrate
# (opcional) bin/rails db:seed
```

5. Arrancar la aplicación en desarrollo:

```bash
# Opción 1 (recomendada con Foreman/Procfile.dev si está disponible):
bin/dev

# Opción 2 (servidor Rails estándar):
bin/rails server -p 3000
```

Abre `http://localhost:3000` en tu navegador.

## 🐳 Despliegue con Docker

1. **Generar `RAILS_MASTER_KEY`:**

```bash
openssl rand -hex 32
```

2. **Construir imagen:**

```bash
docker build -t sistema_ventas .
```

3. **Ejecutar contenedor:**

```bash
docker run -d \
  -p 3000:3000 \
  -e RAILS_ENV=development \
  -e RAILS_MASTER_KEY=<clave_generada> \
  --name sistema_ventas \
  sistema_ventas
```

Para despliegue en producción y configuración avanzada, ver [DEPLOYMENT.md](DEPLOYMENT.md).

## ⚠️ Nota sobre assets y Sprockets

Este proyecto usa Sprockets para algunos assets. Si ves el error:

```
Sprockets::Railtie::ManifestNeededError: Expected to find a manifest file in `app/assets/config/manifest.js`
```

Asegúrate de que existe `app/assets/config/manifest.js` con al menos:

```js
//= link_tree ../images
//= link_directory ../javascripts .js
//= link_directory ../stylesheets .css
```

Después ejecuta `bin/rails assets:precompile` localmente o reconstruye la imagen Docker.

## ▶️ Ejecutar en desarrollo

- Registrar un usuario (Devise) y acceder al panel.
- Ir a `Productos` para crear productos.
- Ir a `Ventas -> Nueva venta` para registrar una venta seleccionando cantidades por producto.

## 🧪 Pruebas

- El proyecto incluye una carpeta `test/` para pruebas (sistema creado con Rails default). Para ejecutar las pruebas:

```bash
bin/rails test
```

- También hay gems `capybara` y `selenium-webdriver` en el grupo `test` para pruebas de sistema.

## 🔐 Variables de entorno (ejemplo `.env.example`)

El proyecto utiliza `config/credentials.yml.enc` para secretos. Como práctica puedes usar variables de entorno para configuraciones adicionales. Ejemplo mínimo de `.env.example`:

```env
# Entorno
RAILS_ENV=development
PORT=3000

# Si usas DATABASE_URL en lugar de sqlite por defecto (opcional):
# DATABASE_URL=sqlite3:db/development.sqlite3

# Opcional: mailer y servicios externos
# SMTP_ADDRESS=smtp.example.com
# SMTP_PORT=587
# SMTP_USER=user@example.com
# SMTP_PASSWORD=secret
```

Nota: las keys de Devise y otros secretos se manejan desde `rails credentials:edit` por defecto.

## 📡 Rutas y endpoints principales

- Autenticación: rutas Devise (`/users/sign_in`, `/users/sign_up`, `/users/password/new`, ...)
- Root: `GET /` -> `home#index`
- Dashboard: `GET /dashboard` -> `home#dashboard` (requiere sesión)
- Productos (CRUD):
  - `GET /productos` -> lista
  - `GET /productos/new` -> formulario nuevo
  - `POST /productos` -> crear (acepta HTML y JSON)
  - `GET /productos/:id` -> ver producto
  - `GET /productos/:id/edit` -> editar
  - `PATCH/PUT /productos/:id` -> actualizar
  - `DELETE /productos/:id` -> eliminar
- Ventas:
  - `GET /ventas` -> listado de ventas del usuario
  - `GET /ventas/new` -> formulario de venta (selección de productos con stock > 0)
  - `POST /ventas` -> crear venta (procesa `params[:productos]` con cantidad por producto)
  - `GET /ventas/:id` -> detalle de la venta (propiedad del usuario)

## 🖼️ Ejemplos de uso (requests)

- Crear un `Producto` vía JSON (API mínima en `ProductosController#create`):

```bash
curl -X POST http://localhost:3000/productos \
	-H "Content-Type: application/json" \
	-d '{"producto": {"nombre": "Camiseta", "precio": 25.5, "stock": 10, "descripcion": "Camiseta azul"}}'
```

Respuesta exitosa (ejemplo):

```json
{
  "id": 123,
  "nombre": "Camiseta",
  "precio": 25.5,
  "stock": 10,
  "descripcion": "Camiseta azul"
}
```

- Registrar una `Venta` desde el formulario (form-urlencoded):

```bash
curl -X POST http://localhost:3000/ventas \
	-d "productos[1]=2" \
	-d "productos[2]=1" \
	-b cookie.txt -c cookie.txt

# Nota: las ventas requieren usuario autenticado; usar cookies o sesión de navegador.
```

El parámetro `productos` debe ser un hash con `producto_id => cantidad`. El controlador validará cantidades y ajustará el `stock` de cada `Producto` llenado `DetalleVenta` y calculando `total`.

## 🤝 Contribuir

1. Haz fork del repositorio.
2. Crea una rama con la feature o fix: `git checkout -b feat/nombre`.
3. Asegúrate que las pruebas pasen: `bin/rails test`.
4. Envía un Pull Request con descripción clara y tickets relacionados.

Por favor abre issues para bugs o propuestas de mejora — describe pasos para reproducir y logs relevantes.

## 📄 Licencia

Este proyecto se publica bajo la licencia **MIT**.

Licencia corta (resumen): puedes usar, copiar, modificar y distribuir el software con la condición de incluir el aviso de copyright y la presente licencia.

## ✍️ Autor

- Jaime
