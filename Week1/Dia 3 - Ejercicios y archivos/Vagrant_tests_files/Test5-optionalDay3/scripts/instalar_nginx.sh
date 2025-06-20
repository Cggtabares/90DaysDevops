
# Instalar nginx
apt update && apt install -y nginx
systemctl start nginx

#Eliminar el archivo index
sudo rm -r /var/www/html/index.nginx-debian.html

#Copiar los archivos de Bootstrap
sudo cp -r /vagrant/scripts/Bootstrap/* /var/www/html

#Cambiar palabras con sed
cd /var/www/html
sudo sed -i 's/CambioEjemplo/Dia 4 - 90DiasDevOPs/g' index.html

#Restart nginx
systemctl restart nginx

# Open html
cat /var/www/html/index.html