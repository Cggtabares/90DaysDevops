#!/bin/bash

LOG="logs_despliegue.txt"

instalar_dependencias() {
  echo "Instalando dependencias..." | tee -a $LOG
  #tee - Command that writes input to both stdout and a file
  sudo apt update && sudo apt install -y python3 python3-pip python3.10-venv nginx git net-tools >> $LOG 2>&1 
  #Redirecciona el mensaje a log y lo agrega pero en este caso seria el error que redirije (2) 
  sudo systemctl enable nginx >> $LOG 2>&1
  sudo systemctl start nginx >> $LOG 2>&1
  
#   So >& is the syntax to redirect a stream to another file descriptor:

# 0 is stdin
# 1 is stdout
# 2 is stderr
# 
# 2> redirects stderr to an (unspecified) file.
# &1 redirects stderr to stdout.
}

clonar_app() {
  echo "Clonando la aplicación..." | tee -a $LOG
  git clone -b booklibrary https://github.com/roxsross/devops-static-web.git >> $LOG 2>&1
  cd devops-static-web
}

configurar_entorno() {
  echo "Configurando entorno virtual..." | tee -a ../$LOG
  python3 -m venv venv && source venv/bin/activate
  #Crea un ambiente llamado venv, puedes usar cualquier nombre y se activa con activate
  #Dentro de este ambiente virtual se instala:
  pip install -r requirements.txt >> ../$LOG 2>&1
  pip install gunicorn >> ../$LOG 2>&1
  
#   Common Naming Conventions
# 1. Generic Names
# bashpython3 -m venv venv          # Most common
# python3 -m venv env           # Also popular
# python3 -m venv .venv         # Hidden directory (starts with dot)

# Directory Structure Examples
# With venv (original)
# devops-static-web/
# ├── venv/
# │   ├── bin/
# │   │   ├── gunicorn
# │   │   ├── python
# │   │   └── pip
# │   └── lib/
# ├── library_site.py
# ├── requirements.txt
# └── static/
# With custom name flask-env
# devops-static-web/
# ├── flask-env/
# │   ├── bin/
# │   │   ├── gunicorn
# │   │   ├── python
# │   │   └── pip
# │   └── lib/
# ├── library_site.py
# ├── requirements.txt
# └── static/
# Best Practices for Naming
# 1. Keep it simple and descriptive
# bash# Good
# python3 -m venv venv
# python3 -m venv env
# python3 -m venv flask-app

# # Avoid
# python3 -m venv this_is_my_very_long_virtual_environment_name


}

configurar_gunicorn() {
  echo "Iniciando Gunicorn..." | tee -a ../$LOG
  # CORREGIDO: Eliminar el :app extra
  #Purpose: Starts the Gunicorn server

# nohup: Runs command immune to hangups (continues after terminal closes)
# -w 4: Uses 4 worker processes
#Rule of thumb: (2 × CPU cores) + 1
#For a 2-core server: (2 × 2) + 1 = 5 workers is optimal
# -b 0.0.0.0:8000: Binds to all interfaces on port 8000
# library_site:app: Points to the Flask app object in the library_site module
# &: Runs in background
# sleep 3: Waits for Gunicorn to fully start
#since the PWD is in venv, we would need to go to the directory where is the log located to save the error
  nohup venv/bin/gunicorn -w 4 -b 0.0.0.0:8000 library_site:app >> ../$LOG 2>&1 &
  sleep 3  # Dar tiempo a que Gunicorn inicie
}


#A reverse proxy sits between clients and your application server:
#            Client → Nginx (Reverse Proxy) → Gunicorn → Flask App
configurar_nginx() {
  echo "Configurando Nginx..." | tee -a ../$LOG
  
  # NUEVO: Eliminar configuración por defecto
  sudo rm -f /etc/nginx/sites-enabled/default
  
  # CORREGIDO: Usar 127.0.0.1:8000 en lugar de 0.0.0.0:8000
  sudo tee /etc/nginx/sites-available/booklibrary > /dev/null <<EOF
server {
    listen 80;      #Listen on HTTP Port
    server_name _;  #Accept any hostname
    
    location / {       #Proxies all requests to Gunicorn on port 8000
        #Preserve client information
        proxy_pass http://127.0.0.1:8000;  ## Forward to same machine that has gunicorn and to port 8000
        proxy_set_header Host \$host;      #Preserves the original Host header, example: If client requests myapp.com, Flask receives Host: myapp.com
        proxy_set_header X-Real-IP \$remote_addr;  #Passes the client's real IP address, example: Flask would see Nginx's IP (127.0.0.1) as the client
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;  #Maintains a chain of proxy IPs, example: X-Forwarded-For: client_ip, proxy1_ip, proxy2_ip
        proxy_set_header X-Forwarded-Proto \$scheme; #Tells Flask if the original request was HTTP or HTTPS
        proxy_redirect off;
    }
    
    location /static/ {  #Serves static files directly (better performance)
        alias $(pwd)/static/;
        expires 30d;
    }
    
    access_log /var/log/nginx/booklibrary_access.log;
    error_log /var/log/nginx/booklibrary_error.log;
}
EOF

#Heredoc (Here Document) is a bash feature that allows you to create multi-line strings 
#or input. It's perfect for writing configuration files, SQL queries, or any multi-line content directly in your script.
#<< signals the start of a heredoc
#DELIMITER is a marker (commonly EOF, but can be any word)
#Everything between the delimiters becomes the input
#The closing delimiter must be on its own line
# Server block:

# Listens on port 80 (HTTP)
# server_name _: Accepts any domain name


# Location blocks:

# /: Proxies all requests to Gunicorn on port 8000
# /static/: Serves static files directly (better performance)


# Proxy headers: Preserve client information
# Logs: Separate access and error logs
# Enables the site and reloads Nginx
# Step-by-Step Process
# 1. Client Request
#    ↓
# 2. Nginx receives on port 80
#    ↓
# 3. Nginx forwards to 127.0.0.1:8000 (Gunicorn)
#    ↓
# 4. Gunicorn worker processes the request
#    ↓
# 5. Flask app generates response
#    ↓
# 6. Response travels back through Gunicorn → Nginx → Client
# Traffic Flow Diagram
# Internet (Port 80)
#       ↓
#    Nginx Server
#    ├─ Static files (/static/) → Direct file serving
#    └─ Dynamic content (/) → Proxy to Gunicorn
#                                     ↓
#                               Gunicorn (Port 8000)
#                               ├─ Worker 1
#                               ├─ Worker 2  
#                               ├─ Worker 3
#                               └─ Worker 4
#                                     ↓
#                               Flask Application

  sudo ln -sf /etc/nginx/sites-available/booklibrary /etc/nginx/sites-enabled/
  sudo nginx -t >> ../$LOG 2>&1 && sudo systemctl reload nginx
}

verificar_servicios() {
  echo "Verificando servicios..." | tee -a ../$LOG
  
  # Verificar Nginx
  if systemctl is-active --quiet nginx; then
    echo "✓ Nginx está activo" | tee -a ../$LOG
  else
    echo "✗ Nginx no está activo" | tee -a ../$LOG
  fi
  
  # Verificar Gunicorn
  if pgrep -f "gunicorn.*library_site" > /dev/null; then
    echo "✓ Gunicorn está corriendo" | tee -a ../$LOG
  else
    echo "✗ Gunicorn no está corriendo" | tee -a ../$LOG
  fi
  
  # Verificar puerto 8000
  if netstat -tlnp | grep -q ":8000"; then   #netstat to see the ports -t (tcp only), -l (listening), -n (numeric), -p (process)
    #grep -q for quiet mode, only return exit status
    #netstat -tlnp | grep -q ":8000" checks if port 8000 is in use
    echo "✓ Puerto 8000 está en uso" | tee -a ../$LOG
  else
    echo "✗ Puerto 8000 no está en uso" | tee -a ../$LOG
  fi
  
  # Probar conexión directa a Gunicorn
  if curl -s http://127.0.0.1:8000 > /dev/null; then
    echo "✓ Gunicorn responde correctamente" | tee -a ../$LOG
  else
    echo "✗ Gunicorn no responde" | tee -a ../$LOG
  fi
}

main() {
  echo "=== Iniciando despliegue de Book Library ===" | tee $LOG
  instalar_dependencias
  clonar_app
  configurar_entorno
  configurar_gunicorn
  configurar_nginx
  verificar_servicios
  
  echo "=== Despliegue finalizado ===" | tee -a ../$LOG
  echo "Revisá $LOG para detalles." | tee -a ../$LOG
  echo "La aplicación debería estar disponible en: http://$(hostname -I | awk '{print $1}')" | tee -a ../$LOG
}

main


