* Historia y arquitectura:
  * App en symfony 1.4
  * Hecha unos zorros con una estructura de varias apps anidadas de una manera muy rara
  * Luego app en php (social)
  * Luego se empieza app en rails
  * Se suspende el proyecto durante 2 años
  * Se quiere retomar ahora

# Dockerizing the symfony app

Cuando se inició el desarrollo de la app en rails se necesitaba que las dos apps en php y la app en rails conviviesen.
En aquel entonces, y casi sin experiencia en nginx y muy poca en rails, I installed the php applications
inside the ```public/``` folder of the rails app. It was not a good decision but at that time I did not know
enough about rails and nginx, time was an issue and I didn't know about docker.
So, the first step in the dockerization process was to
extract all those files back to be able to add them to the new docker image. 

Since I will use the docker tag "symfony" for this image, I will be refering to it as the "symfony" image in the rest of the 
posts.

Our symfony in production is running through an apache server with an old php version installed as an apache module. 
As most of the php applications writen at that time, we used a MySql database.

## What containers do we need?

This legacy application is not used anymore. It app has a frontend and an administration interface. Only the frontend is 
used at the moment, no new content has been created in the last 4 years and no new content will be ever created
using it again. The code is not being manteined and no new commits are made to the git repository.
What we actually need is a sort of snapshot of the running frontend to be able to keep it running until the
new rails app is up and running, the old content is imported and the old app can be discarded. 


For this reason, we will use the following containers:
- A container running same legacy version of MySql we are running know in production
- A container with apache running php as an apache module. The image for this container will contain all the 
  legacy symfony code, assets and uploaded images needed to run the application.

We do not need a development container for this applications sinde, as I alredy told you, this app is dead.

## Extract the symfony application

In production, the symfony app is running in two directories:

- /rails/path/public
- /var/www/vhosts/application-host/httpdocs

Using this tar command we could extract all the files needed by the nginx container. We skip de public/uploads folder
because it's too big and we will transfer it using unison or rsync.


```bash
tar cvf /mnt/lvfotos/public.tar -C ~extremadura_com/rails_projects/extcom --exclude='public/uploads/*' --exclude='*/.git/*' --exclude='*.php' --exclude='*.yml' --exclude='*.xml' --exclude='*.cache' public/
```

```
ESTE COMANDO NO SE USA, lo dejo porque empecé a hacerlo de esta forma.
tar cf /mnt/lvfotos/extremadura.com.tar  \
    --exclude='*/public/assets*' \
    --exclude='*/public/dist/*' \
    --exclude='*/public/packs/*' \
    --exclude='*/public/uploads*' \
    --exclude='*/public/extremadura/web/uploads/*' \
    --exclude='*/.git*' \
    --exclude='*/uploads_orig*' \
    --exclude='*/sitemaps/*' \
    extremadura.com/rails_projects/extcom/public/

tar cf /mnt/lvfotos/extremadura_web_updloads.tar /var/www/vhosts/extremadura.com/rails_projects/extcom/public/extremadura/web/uploads/

tar cf /mnt/lvfotos/guiaextremadura.com.tar \
    --exclude='*agenda/httpdocs/uploads*' \  
    /var/www/vhosts/guiaextremadura.com

tar cf /mnt/lvfotos/guiaextremadura_subdomains_agenda_httpdocs_uploads.tar \
    -C /var/www/vhosts/guiaextremadura.com/subdomains/agenda/httpdocs/ \
    uploads/ uploads2/

tar cf /mnt/lvfotos/uploads.tar -C /mnt/lvfotos/public/uploads \
    --exclude='*/pg_models*' \ 
    --exclude='*/user/*' \
    --exclude='*/lead/*' \
    --exclude='*/event/*' \ 
    --exclude='*/place/*' \
    --exclude='*/territory/*' \
    --exclude='*/link/*' \
    --exclude='*/guide/*' \
    --exclude='*/podcast/*' \
    --exclude='*/product/*' \
    --exclude='*/destination/*' \
    --exclude='*/album/*' \
    --exclude='*/_cache/*' \
    --exclude='*/people_and_groups/*' \
    --exclude='*/video/*' \
    --exclude='*/post/*' \
    --exclude='*/picture/*' \
    .
```

...I hope you start to see why I said that it was not a good idea to put the files of the symfony application in
the public folder of the rails app.

Once we have the code, assets and uploaded documents, we need a backup of the database to restore it in our mysql container:

```
# mysqldump -u root -p --all-databases > backup.mysql
```


Cambiar la configuración de la App en symfony:

```
mysql:dbname=guiaextremadura2010;host=localhost 
                                      ^^^^^^^^^

mysql:dbname=guiaextremadura2010;host=mysql
```

busqué todos los ficheros de symfony en los que estaba esta configuración con ack y la cambié.

Luego tuve que poner los Alias que me faltaban:

```
        Alias /uploads/artistas /var/www/vhosts/guiaextremadura.com/httpdocs/uploads/artistas
        Alias /uploads/establecimientos /var/www/vhosts/guiaextremadura.com/httpdocs/uploads/establecimientos
        Alias /uploads/promociones /var/www/vhosts/guiaextremadura.com/httpdocs/uploads/promociones

        Alias /agenda/uploads/artistas /var/www/vhosts/guiaextremadura.com/httpdocs/uploads/artistas
        Alias /agenda/uploads/especiales /var/www/vhosts/guiaextremadura.com/httpdocs/uploads/especiales
        Alias /turismo/uploads/establecimientos /var/www/vhosts/guiaextremadura.com/httpdocs/uploads/establecimientos
        Alias /agenda/uploads/eventos /var/www/vhosts/guiaextremadura.com/httpdocs/uploads/eventos
        Alias /cartelera/uploads/gallery /var/www/vhosts/guiaextremadura.com/httpdocs/uploads/gallery
        Alias /turismo/uploads/promociones /var/www/vhosts/guiaextremadura.com/httpdocs/uploads/promociones
```

Se mantuvo la app según estaba, con el mismo caos. Al final lo que queremos es dockerizarla para poder trabajar con ella
como un contenedor o caja negra y moverlo de un sitio para otro.

Como extra, al hacer las pruebas vimos que se estaba produciendo un error y lo corregí...


# Dockerizando /social

## Extraer ficheros del servidor
 
Hacemos tres ficheros `tar` con el contenido, la base de datos y el código:

* Uno con el código fuente:
  ```bash
  > tar cfvp  ~/social.tar --exclude='*/public/*' --exclude='*temporary/*' --exclude='*/.git*' .
  ```
* Otros dos con las carpetas `public/` y `temporary`:
   ```bash
   > tar cfp  ~/social_public.tar public/
   > tar cfp  ~/social_temporary.tar temporary/ 
   ```
* Hacemos un volcado de la base de datos, en este caso lo hacemos usando la interfaz de plesk para generar un fichero
  `ceronet_social_2019-11-18_11-55-57.sql.zip`.

## Desplegando el servicio

### Volúmenes

Se montan dos volúmenes en la aplicación: uno para `public/` y otro para `temporary/`.

Importante montar esos volúmenes en el disco adecuado, ya que no queremos que se llene el disco raiz.

### Cargar la base de datos en el contenedore de mysql

* Levantamos el contenedor con la base de datos:
  ```bash
  > docker run -d --rm --name auxcontainer -v  $(pwd)/ceronet_social_2019-11-18_11-55-57.sql:/tmp/ceronet_social_2019-11-18_11-55-57.sql -v $(pwd)/docker-data/mysql-5.5.37/:/var/lib/mysql mysql/mysql-server:5.5
  ```
* Accedemos al contenedor:
  ```bash
  > docker exec -ti auxcontainer bash
  ```
* Creamos la base de datos y damos acceso al usuario:
  ```bash
  > mysql -u root -p
  mysql> CREATE DATABASE ceronet_social;
  mysql> GRANT ALL ON ceronet_social.* TO redsocial2@'%' IDENTIFIED BY 'password';
  mysql> exit
  > exit
  ```
* Salimos del contenedor y lo apagamos:
  ```bash
  > docker container stop auxcontainer
  ```

### Qué hacer para incluir el código en la imagen

Descomprimir el código en la carpeta ./social: el Dockerfile cogerá el código de aquí.

Cambiar el host de la base de datos, que debería ser `mysql` (nombre del servicio en docker-compose). Esto está en el fichero
`social/application/settings/database.php`

El Dockerfile, incluirá el código en la carpeta `/var/www/vhosts/extremadura.com/rails_projects/extcom/public//social` dentro
del contenedor.

### ¿Cómo montar los volúmenes para ver las imágenes?
