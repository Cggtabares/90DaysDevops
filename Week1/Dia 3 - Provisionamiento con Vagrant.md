## 🚀 Vagrant: Automatización con Shell

### Vagrant 
Es un software que te permite crear maquinas virtuales en segundos, automatizar entornos y usar Shell/Bash para configuraciones iniciales.

- Puedes destruir y volver a crear VMs en segundos

---

## 🔧 Instalación Rápida

1. Instalar VirtualBox (Hipervisor)
```bash
sudo apt update && sudo apt install virtualbox -y  # Debian/Ubuntu
brew install --cask virtualbox  # macOS
```

2. Instalar Vagrant
```bash
wget -O - https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg  #Linux Debian/Ubuntu

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(grep -oP '(?<=UBUNTU_CODENAME=).*' /etc/os-release || lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list #Linux Debian/Ubuntu

sudo apt update && sudo apt install vagrant  # Linux Linux Debian/Ubuntu
brew install vagrant  # macOS
```

3. Verificar instalación
```bash
vagrant --version
# Debe mostrar: Vagrant 2.3.x o superior
```
---

## Resultado
[Vagrant_instalado](image_location)

---

## 🛠️ Instalación en Windows

### 1. Instalar prerequisitos (elige una opción)
Opción A: Hyper-V (Recomendado para Windows Pro/Enterprise)
```Powershell
# En PowerShell como Administrador
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V -All
```

Opción B: VirtualBox - Eleji esta para reproducir los ejercicios
Descargar instalador desde virtualbox.org

### 2. Instalar Vagrant
Descargar desde vagrantup.com y ejecutar el .msi

### 3. Verificar instalación
```bash
vagrant --version
:: Debe mostrar: Vagrant 2.3.x+
```

---

## 🚀 Comandos Esenciales

| Comando	                  | Descripción                                             |
|-----------------------------|---------------------------------------------------------|
| vagrant up	              | Inicia la máquina virtual                               |
| vagrant ssh	              | Conectarse via SSH (necesita cliente como Git Bash)     |
| vagrant halt	              | Apagar la VM                                            |
| vagrant destroy	          | Eliminar la VM completamente                            |
| vagrant reload --provision  | Reiniciar y re-ejecutar provisionamiento                |

---

## 📦 Vagrant Boxes: Arquitectura y Fuentes Oficiales

Un Box es un paquete portable que contiene:
- Sistema Operativo base (Ubuntu, CentOS, Windows, etc)
- Configuracion minima para funcionar con Vagrant
- Metadatos de version y proveedor (VirtualBox, Hyper-V, etc)

---

### 🏗️ Arquitectura Técnica de los Boxes

#### 1. Formatos de Boxes
| Formato   | Descripción	                  | Uso típico               |
|-----------|---------------------------------|--------------------------|
| .box	    | Paquete comprimido (tar + gzip) |	Distribución pública     |
| OVA/OVF	| Estándar abierto para VMs	      | Importación/Exportación  |
| VHD/VMDK	| Discos virtuales nativos	      | Hyper-V/VMware           |

#### 2. Estructura Interna
```bash
ubuntu-jammy64/
├── Vagrantfile          # Config base
├── metadata.json        # Versión, proveedor
└── virtualbox/          # Directorio específico
    ├── box.ovf          # Descriptor de VM
    ├── *.vmdk           | Discos virtuales
    └── Vagrantfile      | Config extra
```

#### 3. Componentes Clave
- metadata.json: Define nombre, versión y proveedor:
```bash
{
  "name": "ubuntu/jammy64",
  "versions": [{
    "version": "20240415.0.0",
    "providers": [{
      "name": "virtualbox",
      "url": "https://example.com/box.virtualbox.box"
    }]
  }]
}
```

---

## 🔧 Tipos de Boxes por Arquitectura

#### 1. Por Sistema Operativo
| Box	             | Arquitectura  | Enlace Oficial  |
|------------------|---------------|-----------------|
| ubuntu/jammy64   | x86_64	       | Ubuntu          |
| centos/stream8   | x86_64	       | CentOS          |
| generic/alpine38 | ARM64	       | Alpine          |

#### 2. Por Hipervisor
```bash
config.vm.box = "debian/bullseye64"
config.vm.box_version = "11.20240325"
config.vm.box_url = "https://app.vagrantup.com/debian/boxes/bullseye64"
```

#### 3. Boxes Multi-Provider
Ejemplo con soporte para VirtualBox y Parallels:
```bash
"providers": [
  {
    "name": "virtualbox",
    "url": "https://example.com/box.vbox.box"
  },
  {
    "name": "parallels",
    "url": "https://example.com/box.parallels.box"
  }
]
```

---

## 🚨 Mejores Prácticas con Boxes

1. Verificar checksums:

```vagrant box add --checksum-type sha256 --checksum 1234... ubuntu/jammy64```

2. Usar versionado semántico:

```config.vm.box_version = "~> 2024.04"```

3. Actualizar boxes periódicamente:

```vagrant box update```

4. Eliminar boxes antiguos:

```vagrant box prune```

---

## 🌟 Boxes Recomendados para DevOps

1. Generales:
    - ubuntu/focal64 (LTS)
    - debian/bullseye64

2. Contenedores:
    - generic/alpine314 (5MB!)
    - rancher/k3os

3. Enterprise:
    - centos/stream9
    - oraclelinux/9

🔗 Lista completa: [Vagrant Cloud - Official Boxes](https://app.vagrantup.com/boxes/search?utf8=%E2%9C%93&sort=downloads&q=official)

---

## 🏗️ Tu Primer Vagrantfile

Crea un archivo ```Vagrantfile``` con este contenido:
El archivo VagrantFile es por proyecto, no hay un comando para poder elegir otro nombre de archivo, siempre tiene que ser VagrantFile

```bash
Vagrant.configure("2") do |config|
  # Usa una imagen ligera de Ubuntu 22.04
  config.vm.box = "ubuntu/jammy64"
  
  # Configuración de red (accesible via IP)
  config.vm.network "private_network", ip: "192.168.33.10"
  
  # Provisionamiento con Shell
  config.vm.provision "shell", inline: <<-SHELL
    echo "¡Hola desde el provisionamiento!" > /tmp/hola.txt
    apt update && apt install -y nginx
    systemctl start nginx
  SHELL
end
```

### 📝 Explicación:
    - ```config.vm.box```: Imagen base (Ubuntu en este caso).
    - ```config.vm.network```: Asigna IP privada.
    - ```config.vm.provision```: Ejecuta comandos Shell al iniciar.

---

## 🚀 Comandos Clave de Vagrant
| Comando	          | Descripción                        |
|-------------------|------------------------------------|
| vagrant init	    | Crea un Vagrantfile básico         |
| vagrant up	      | Inicia la VM (+ provisionamiento)  |
| vagrant ssh	      | Conéctate a la VM por SSH          |
| vagrant halt	    | Apaga la VM                        |
| vagrant destroy	  | Elimina la VM (¡cuidado!)          |
| vagrant provision	| Re-ejecuta el provisionamiento     |

Ejemplo práctico:
```bash
vagrant up  # Inicia la VM y ejecuta el Shell provisioner
vagrant ssh  # Accede a la VM
cat /tmp/hola.txt  # Verifica el archivo creado
```

---

### Errores Comunes

1. Si estas corriendo una VM en WIndows y dentro de esa VM, estas ejecutando Vagrant. Esto es un Nest of VM, VirtualBox lo tiene bloqueado pero puedes correrlo, si vas al directorio donde esta instalado VirtualBox y abrir la terminal, debes ejecutar este comando:
```VBoxManage.exe modifyvm Ubuntu --nested-hw-virt on```

---

## 🛠️ Provisionamiento Avanzado con Shell

### Caso real: Instalar Docker + Kubernetes
Modifica tu ```Vagrantfile```:
```bash
config.vm.provision "shell", inline: <<-SHELL
  # Instalar Docker
  apt update
  apt install -y docker.io
  systemctl enable --now docker
  
  # Instalar kubectl
  curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
  install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
  
  # Verificar
  docker --version && kubectl version --client
SHELL
```

---

## 💡 Pro Tip:

Usa **scripts externos** para organizar mejor tu código:

```config.vm.provision "shell", path: "scripts/instalar_docker.sh"```

---

## 🔍 Debugging y Logs

- Ver output del provisionamiento:

```vagrant up --provision | tee vagrant.log```

- Si falla el Shell:

Conéctate a la VM: vagrant ssh
Revisa logs en /var/log/cloud-init-output.log

---

## 📂 Estructura Recomendada de Proyecto
```bash
mi_proyecto/
├── Vagrantfile          # Config principal
├── scripts/            # Scripts de provisionamiento
│   ├── instalar_nginx.sh
│   └── configurar_db.sh
└── README.md           # Documentación
```

---

## 📚 Tarea Opcional del Día 3

Crea una VM con:
1. Nginx instalado.
2. Un archivo en ```/var/www/html/index.html``` con tu nombre. ó puedes vistar esta web con un monton de template web
3. Accesible via browser en ```http://192.168.33.10 #Direccion Ip de red Interna.
```bash
# Solución (¡inténtalo antes de ver esto!)
config.vm.provision "shell", inline: <<-SHELL
  apt update && apt install -y nginx
  echo "<h1>Hola, soy [TuNombre]</h1>" > /var/www/html/index.html
SHELL
```

**Armá tu propio entorno con**:
    1. Una IP privada distinta
    2. Otro paquete instalado (por ejemplo: git, curl o docker.io)
    3. Personaliza el mensaje del index.html con tu nombre y fecha

Muestra tu resultado

![BootstrapinVM](imagenlocation)

- Subí una captura de tu navegador mostrando el index.html
- O compartí el contenido de tu bootstrap.sh con el hashtag #DevOpsConRoxs

---

## 🌟 Beneficios para DevOps

- Reproducibilidad: Mismo entorno en todos lados.
- Velocidad: ```vagrant destroy && vagrant up``` = Entorno nuevo en 1 minuto.
- Integración con CI/CD: Usa Vagrant en pipelines.