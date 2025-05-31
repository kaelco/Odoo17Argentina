# Odoo 17 + AFIP WS Argentina - Docker Deployment

Este repositorio contiene una instalación de Odoo 17 configurada con:

- Localización Argentina (`l10n_ar`, `l10n_ar_afipws`)
- Facturación electrónica con AFIP
- Docker + Docker Compose
- Certificados digitales
- Addons personalizados

---

## 📦 Requisitos previos

- Docker Engine ≥ 20.10
- Docker Compose ≥ 2.0
- Git

---

## 📁 Estructura del proyecto

```
.
├── docker-compose.yml
├── Dockerfile
├── config
│   └── odoo.conf
├── certs
│   ├── certificado.crt
│   ├── clave.key
│   └── openssl.cnf
├── extra-addons
│   └── l10n_ar_afipws/ (y otros addons personalizados)
└── README.md
```

---

## 🚀 Instalación paso a paso

### 1. Clonar este repositorio

```bash
git clone https://github.com/tunombre/odoo17-afip-docker.git
cd odoo17-afip-docker
```

### 2. Crear volúmenes y redes

```bash
docker volume create odoo17-data
docker volume create postgres-data
```

---

### 3. Construir y levantar contenedores

```bash
docker-compose up --build -d
```

Esto creará los contenedores:

- `odoo17-web`: Odoo con módulos personalizados
- `odoo17-db`: PostgreSQL

---

## 🧾 Certificados AFIP

Los certificados deben estar en la carpeta `certs/`:

- `certificado.crt`: certificado firmado por AFIP
- `clave.key`: clave privada
- `openssl.cnf`: archivo de configuración para OpenSSL

Asegurate de que estén montados en el contenedor (`/etc/ssl/certs/afip/`).

### Automatización en Dockerfile

```dockerfile
COPY ./certs /etc/ssl/certs/afip/
```

---

## 🧩 Instalar dependencias adicionales

Para facturación electrónica es necesario el módulo Python `pyafipws`:

```Dockerfile
RUN pip3 install git+https://github.com/reingart/pyafipws.git
```

También podés agregar:

```Dockerfile
RUN apt-get update && apt-get install -y \
    libxml2-dev \
    libxslt1-dev \
    libzip-dev \
    libldap2-dev \
    libsasl2-dev \
    libssl-dev \
    && pip3 install -r requirements.txt
```

---

## 🛠️ Configuración inicial en Odoo

1. Entrar a http://localhost:8069
2. Crear base de datos
3. Instalar `l10n_ar`, `l10n_ar_afipws`, y `account_accountant`
4. En **Contabilidad > Configuración > Certificados**:
   - Cargar certificado (`.crt`) y clave (`.key`)
   - Confirmar y generar el alias
5. Configurar diario de ventas con punto de venta AFIP

---

## 🔁 Comandos útiles

```bash
docker-compose restart
docker-compose logs -f
docker exec -it odoo17-web bash
```

---

## 📂 Backups

Para realizar backups automáticos o manuales:

```bash
docker exec -it odoo17-web ./odoo-bin -d <nombre_db> -c /etc/odoo/odoo.conf -r postgres -w <pass> --backup > backup.zip
```

---

## 📞 Soporte

Para soporte técnico personalizado, contactá a:

**Kaelco Sistemas**  
Email: info@kaelco.com.ar  
WhatsApp: +54 341 420183

---

## 📝 Licencia

Este proyecto se distribuye bajo los términos de la licencia MIT.
