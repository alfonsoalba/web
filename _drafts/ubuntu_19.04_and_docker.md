Instalar ubuntu

Instalar docker siguiendo la documentación

Añadir usuario al grupo ubuntu:
```bash
sudo useradd ubuntu docker
```

Al ejecutar `docker run --rm hello-world` da un error:

```
Oct 12 06:27:39 wozniak dockerd[3780]: time="2019-10-12T06:27:39.463645531Z" level=error msg="Handler for POST /v1.40/containers/69bea6d39ec298eaca64ebf1c9864a92846f148c57ede7403885ac0b7c55366b/start returned error: AppArmor enabled on system but the docker-default profile could not be loaded: running `/usr/sbin/apparmor_parser apparmor_parser -Kr /var/lib/docker/tmp/docker-default391457620` failed with output: AppArmor parser error for /var/lib/docker/tmp/docker-default391457620 in /etc/apparmor.d/tunables/global at line 17: Could not open 'tunables/proc'\n\nerror: exit status 1"
```

El problema es que el puto ubuntu le falta un fichero: `/etc/apparmor.d/tunables/proc`.

miré la versión que tenía instalada:

```
> sudo dpkg -l apparmor
Desired=Unknown/Install/Remove/Purge/Hold
| Status=Not/Inst/Conf-files/Unpacked/halF-conf/Half-inst/trig-aWait/Trig-pend
|/ Err?=(none)/Reinst-required (Status,Err: uppercase=bad)
||/ Name           Version           Architecture Description
+++-==============-=================-============-======================================
ii  apparmor       2.13.2-9ubuntu6.1 amd64        user-space parser utility for AppArmor
```

Me fui a eeste enlace: https://launchpad.net/ubuntu/+source/apparmor 

busqué la versión

Me descargué el paquete: 

```bash
wget https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/apparmor/2.13.3-5ubuntu1/apparmor_2.13.3.orig.tar.gz
```

Estraer el fichero:

```bash
tar xfz apparmor_2.13.3.orig.tar.gz apparmor-2.13.3/profiles/apparmor.d/tunables/proc
```

Moverlo:

```bash
sudo mv apparmor-2.13.3/profiles/apparmor.d/tunables/proc /etc/apparmor.d/tunables/
```

Y con esto, docker funciona:

```bash
docker run --rm hello-world

Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
    (amd64)
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.

To try something more ambitious, you can run an Ubuntu container with:
 $ docker run -it ubuntu bash

Share images, automate workflows, and more with a free Docker ID:
 https://hub.docker.com/

For more examples and ideas, visit:
 https://docs.docker.com/get-started/
```

