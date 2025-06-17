# Day 1 - Welcome

## 🔥 ¿Qué es DevOps?

DevOps es una metodologia y cultura que permite a los equipos poder trabajar de forma colaborativa, compartiendo ideas y usando herramientas para que el desarrollo del software sea mas rapido, estable y con menos errores. 🚀

-----

## 🌟 Beneficios de la Cultura DevOps

✅ **Entrega más rápida**: Automatización = menos errores y actualizaciones en minutos.
✅ **Mejor calidad**: Pruebas continuas = menos bugs en producción.
✅ **Sistemas más estables**: Monitoreo automático = menos caídas.
✅ **Más innovación**: Ciclos cortos = experimentar sin miedo.
✅ **Mejor colaboración**: Todos comparten responsabilidades.

-----

## El papel de Linux en DevOps

Linux es el **Corazon de DevOps** y del mundo IT. Cerca del **90% de los servidores en produccion usan Linux.**

## 🔥 Razones por las que Linux DOMINA en DevOps:

- Las empresas de Cloud como AWS, Google y Azure... todos usan Linux
- Linux es Open Source asi que puede ser usado por todos
- Puedes **Automatizar** todo desde la terminal de comandos
- Los contenedores de Docker usan el kernel de Linux
- La seguridad en Linux es bastante fuerte dependiendo de como se configure


## Herramientas que Usan Linux

| Herramienta     |	¿Por qué necesita Linux?                           |
|-----------------|----------------------------------------------------|
| Docker          |	Usa el kernel de Linux para contenedores.          |
| Kubernetes      |	Corre nativamente en Linux.                        | 
| Terraform	      | Gestiona infraestructura en la nube (Linux-based). |
| Ansible	      | Automatiza servidores (SSH + Python = Linux).      |
| Jenkins         |	CI/CD más eficiente en Linux.                      |

## 📌 ¿Por qué todo DevOps Engineer DEBE aprender Linux?

- El 80% del trabajo DevOps es en CLI
- Creacion de Scripts que automatizan trabajo manual
- Creacion y orquestacion de contenedores, sin Linux no hay esto.
- Personalizacion de servidores para su control total

------

## 📚 Tarea Opcional del Día 1

1. **🧠 Reflexión Personal**
DevOps es una metodologia y cultura que permite a los equipos poder trabajar de forma colaborativa, compartiendo ideas y usando herramientas para que el desarrollo del software sea mas rapido, estable y con menos errores. 🚀

2. 🖥️ Primeros Pasos en Linux
- Prueba estos comandos:
`code`
```bash
whoami #- Mostrara en pantalla el usuario 
pwd    #- Mostrara el directorio en el cual esta trabajando el usuario
ls -lah  #- Listar archivos o directorios (-l lista larga, -a todos los archivos. inlcuyendo los ocultos, -h mostrara los pesos en KB)
mkdir devops-d1 #- Crear una directorio llamado devops-d1
cd devops-d1  #- Cambiar de directorio actual hacia el devops-d1
echo "Hola DevOps" > hola.txt #- Mostrara en pantalla Hola DevOps, > esto sirve para redirigir el texto y guardarlo en el archivo hola.txt
cat hola.txt #- Mostrar el contenido del archivo hola.txt
```

3. 🎯 Desafío: ¡Linux Detectives!

- ¿Cuánto tiempo lleva encendido tu sistema?

```bash
uptime # Muestra hora y tiempo encendida
```
- ¿Qué procesos están consumiendo más recursos?

```bash
top # Muestra los procesos que se estan corriendo actualmente en la maquina con su uso en CPU, Memoria y otros
```

- ¿Cuánta memoria disponible tienes?

```bash
free -h # Muestra la memoria libre que tiene la maquina
```