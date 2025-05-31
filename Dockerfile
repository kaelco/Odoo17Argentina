FROM odoo:17

USER root

# Instalar herramientas necesarias
RUN apt-get update && apt-get install -y \
    git \
    swig \
    libssl-dev \
    python3-dev \
    build-essential \
    libffi-dev \
    nano \
    && rm -rf /var/lib/apt/lists/*

# Crear carpetas necesarias y dar permisos
RUN mkdir -p /opt/afip_cache \
 && chmod -R 777 /opt/afip_cache \
 && mkdir -p /usr/local/lib/python3.10/dist-packages/pyafipws/cache \
 && chown -R odoo:odoo /usr/local/lib/python3.10/dist-packages/pyafipws/cache \
 && chmod -R 777 /usr/local/lib/python3.10/dist-packages/pyafipws/cache

# Copiar requirements e instalar
COPY requirements.txt /tmp/requirements.txt
RUN pip3 install --upgrade pip \
 && pip3 install -r /tmp/requirements.txt \
 && pip3 install m2crypto

# Copiar archivo openssl.cnf al lugar deseado (ajustalo si es necesario)
COPY openssl.cnf /etc/ssl/openssl.cnf

# Asignar permisos por si se sobreescribe
RUN chmod 644 /etc/ssl/openssl.cnf

USER odoo


