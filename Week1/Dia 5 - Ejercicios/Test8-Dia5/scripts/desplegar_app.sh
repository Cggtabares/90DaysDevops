#!/bin/bash

LOG="logs_pm2.txt"

instalar_dependencias() {
  echo "Instalando dependencias..." | tee -a $LOG
  sudo apt update && sudo apt install -y nginx nodejs npm >> $LOG 2>&1
  sudo systemctl enable nginx >> $LOG 2>&1
  sudo systemctl start nginx >> $LOG 2>&1

}

configurar_entorno() {
  echo "Configurando entorno virtual..." | tee -a ../$LOG
  sudo npm install pm2 -g >> ../$LOG 2>&1
  sleep 3
}

clonar_app() {
  echo "Clonando la aplicación..." | tee -a $LOG
   git clone -b ecommerce-ms https://github.com/roxsross/devops-static-web.git >> $LOG 2>&1
  cd devops-static-web
}

#instalar dependencias por folder
instalar_dependencias_app() {
        echo "Instalando dependencias por carpeta..." | tee -a ..//$LOG
        echo "Instalando dependencias de frontend"
        cd frontend/
        npm install
        cd ..
        echo "Instalando dependencias de merchandise"
        cd merchandise/
        npm install
        cd ..
        echo "Instalando dependencias de products"
        cd products/
        npm install
        cd ..
        echo "Instalando dependencias de shopping-cart"
        cd shopping-cart/
        npm install
        cd ..
}

configurar_pm2() {
  echo "Iniciando pm2..." | tee -a ../$LOG
  sudo tee ./ecosystem.config.js > /dev/null <<EOF
  module.exports = {
  apps: [
    {
      name: 'app1-frontend',
      script: './frontend/server.js'
      //# Se levanta en puerto 3000 pero no se coloca el puerto debido a que NGinx manejara el proxy 
      //#y la pagina de frontend manejara el enrutamiento interno
    },
    {
      name: 'app2-products',
      script: './products/server.js'
      // Se levanta en puerto 3001
    },
    {
      name: 'app3-merchandise',
      script: './merchandise/server.js'
      // Se levanta en puerto 3002
    },
    {
      name: 'app4-shopping-cart',
      script: './shopping-cart/server.js'
      // Se levanta en puerto 3001
    }
  ]}
EOF

  pm2 start ecosystem.config.js >> ../$LOG 2>&1 &
  sleep 3  # Dar tiempo a que PM2 inicie
}

configurar_nginx() {
  echo "Configurando Nginx..." | tee -a ../$LOG
  
  # NUEVO: Eliminar configuración por defecto
  sudo rm -f /etc/nginx/sites-enabled/default
  
  sudo tee /etc/nginx/sites-available/ecommerce-ms > /dev/null <<EOF
server {
    listen 80;
    server_name _;
    
    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        proxy_redirect off;
    }
    
    location /static/ {
        alias $(pwd)/static/;
        expires 30d;
    }
    
    access_log /var/log/nginx/ecommerce-ms_access.log;
    error_log /var/log/nginx/ecommerce-ms_error.log;
}
EOF
  
  sudo ln -sf /etc/nginx/sites-available/ecommerce-ms /etc/nginx/sites-enabled/
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
  
  # Verificar puerto 3000
  if netstat -tlnp | grep -q ":3000"; then
    echo "✓ Puerto 3000 está en uso" | tee -a ../$LOG
  else
    echo "✗ Puerto 3000 no está en uso" | tee -a ../$LOG
  fi
  
  # Probar conexión directa a PM2
  if curl -s http://127.0.0.1:3000 > /dev/null; then
    echo "✓ PM2 responde correctamente" | tee -a ../$LOG
  else
    echo "✗ PM2 no responde" | tee -a ../$LOG
  fi
}

main() {
  echo "=== Iniciando despliegue de Book Library ===" | tee $LOG
  instalar_dependencias
  configurar_entorno
  clonar_app
  instalar_dependencias_app
  configurar_pm2
  configurar_nginx
  verificar_servicios
  
  echo "=== Despliegue finalizado ===" | tee -a ../$LOG
  echo "Revisá $LOG para detalles." | tee -a ../$LOG
  echo "La aplicación debería estar disponible en: http://$(hostname -I | awk '{print $1}')" | tee -a ../$LOG
}

main