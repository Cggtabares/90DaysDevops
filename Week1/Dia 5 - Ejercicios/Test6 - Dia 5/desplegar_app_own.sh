#!/bin/bash
# Script deploy app

instalar_dependencias() {
  sudo apt update
  sudo apt install -y python3 python3-pip python3-venv nginx git
}
instalar_dependencias

git clone -b booklibrary https://github.com/roxsross/devops-static-web.git
cd devops-static-web
python3 -m venv venv && source venv/bin/activate
pip install -r requirements.txt
pip install gunicorn 

gunicorn -w 4 -b 127.0.0.1:8000 library_site:app:app

#Configurar NGiNX
# Nginx puerto 8000
sudo nano /etc/nginx/sites-enabled/default

# Añadir la siguiente configuración al archivo de Nginx

