# News API - Challenge
_Proyecto reto de desarrollo de API para obtener distintas Noticias._

## Contenido
- [Caracteríticas](#características)
  - [Generales](#generales)
  - [Especiales](#especiales)
- [Requerimientos](#requerimientos)
- [Instalación](#instalación)
  - [Instalar contenedor PostgreSQL](#instalar-contenedor-postgresql)
  - [Ejecución del proyecto](#ejecución-del-proyecto)
    - [Instalar contenedor PostgreSQL](#instalar-contenedor-postgresql)
    - [Sin contenedor](#sin-contenedor)
    - [Con contenedor](#con-contenedor)

## Características
### Generales
- Obtener toda información de las noticias registradas en base de datos en formato JSON.

### Especiales
- Registrar, eliminar y presentar la información de una noticia o fuente.
- Carga de información en base de datos a través de comandos desde [News API](https://newsapi.org/).

## Requerimientos

Para la ejecución del proyecto se requiere como mínimo:
- [Git](https://git-scm.com/downloads) - Sistema de control de versiones distribuido de código abierto y gratuito.
- [Ruby](https://www.ruby-lang.org/es/documentation/installation/) - Lenguaje de programación interpretado, reflexivo y orientado a objetos.
- [PostgreSQL](https://www.postgresql.org/download/) - Sistema gestor de bases de datos relacional.
- [Docker](https://www.docker.com/get-started/) - Plataforma que permite el despligue automático de aplicaciones en contenedores.
- [Visual Studio Code](https://code.visualstudio.com/download) - Visual Studio Code es un editor de código fuente multiplataforma. (Puede usar cualquier IDE o editor de texto como: RubyMine, Aptana, etc...).

## Instalación

Para ejecutar el proyecto se requiere tener [PostgreSQL](https://www.postgresql.org/download/) localmente. Otro medio es usar contenedores por lo cual se describe la solución usando [Docker](https://www.docker.com/get-started/):

### Instalar contenedor PostgreSQL

> 1. Descargar la imagen:
>
> ```bash
> docker pull postgres:latest
> ```
> 2. Crear un volumen para datos del contenedor:
> ```bash
> docker network create rails-postgres-nt
> ``` 
>
> 2. Crear un volumen para datos del contenedor:
> ```bash
> docker volume create postgres-vl
> ```
>
> 3. Contruir el contenedor con las configuraciones correspondientes:
> ```bash
> docker run -d --name postgres-ct -p 5432:5432 --network rails-postgres-nt -e POSTGRES_PASSWORD=<clave> -e POSTGRES_USER=<usuario> -v postgres-vl:/var/lib/postgresql/data postgres:latest
> ```

### Ejecución del proyecto local

> 1. Obtener y guardar la clave maestra del proyecto en variable de entorno del sistema:
> ``` bash
> export RAILS_MASTER_KEY=$(curl -sS https://gist.githubusercontent.com/edgewl2/41646a96ed0eb106671f466786b815b9/raw/21bb726dfd752619acb3aa88820a47ecbb061ab5/masterKey.txt)
> ```
> 
> 2. Guardar en una variable de entorno del sistema:
>
> ```bash
> git clone https://github.com/edgewl2/ror_news_api.git news_backend
> ```
>
> 3. Acceder al directorio raíz del proyecto:
> ```bash
> cd news_backend
> ```

#### Sin contenedor

> 1. Crear las bases de datos:
> ```bash
> rails db:setup
> ```
>
> 2. Realizar la migracion de entidades:
> ```bash
> rails db:migrate
> ```
> 
> 3. Cargar información en base de datos:
> 
> Existen dos formas de realizar este proceso por CLI, usando una rake task y a través de seeds.
> ```bash
> rails db_fetch:fill
> ```
> 
> ```bash
> rails db:seed
> ```
> 
> 4. Iniciar servidor:
> ```bash
> rails server
> ```

#### Con contenedor

Se puede realizar de dos maneras diferentes.

- Usando Docker Compose
> 1. Ejecutar los servicios de la aplicación configurados:
> ```bash
> docker-compose up -d
> ```
> *NOTA:* En este momento se pueden realizar las pruebas correspondientes usando un cliente REST como: [Postman](https://www.postman.com/downloads/), [Insomnia](https://insomnia.rest/download), o el Front-end desarrollado.
> 
> 2. Detener y eliminar los servicios:
> ```bash
> docker-compose down
> ```

- Usando Docker Engine
> 1. Construir la imagen a partir:
> ```bash
> docker build . -t edgewl2/rails:latest
> ```
> 2. Obtener la dirección IP usada por el contenedor PostgreSQL a través de su información:
> ```bash
> docker container inspect postgres-ct | jq '.[0].NetworkSettings.Networks | .[].IPAddress'
> ```
> 
> Otra alternativa es conseguirla a través de la información de la red asociada:
> ```bash
> docker network inspect rails-postgres-nt | jq '.[0].Containers | .[].IPv4Address / "/" | .[0]'
> ```
> 
> 3. Guardamos la dirección IP en una variable de entorno del sistema:
> ```bash
> export POSTGRES_HOST=<IP contenedor>
> ```
>
> 4. Creamos el contenedor del API Rails:
> ```bash
> docker run -d --name news-api-ct -p 3000:3000 --network rails-postgres-nt -e RAILS_MASTER_KEY=$RAILS_MASTER_KEY -e POSTGRES_HOST=$POSTGRES_HOST edgewl2/rails:latest
> ```
> *NOTA:* En este momento se pueden realizar las pruebas correspondientes usando un cliente REST como: [Postman](https://www.postman.com/downloads/), [Insomnia](https://insomnia.rest/download), o el Front-end desarrollado.
>
> 5. Parar los contenedores:
> ```bash
> docker stop $(docker ps -q)
> ```
