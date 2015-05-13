## Kuali Coeus Tomcat Dockerfile

This repository contains **Dockerfile** of [Tomcat](http://tomcat.apache.org/) for [Docker](https://www.docker.com/)'s [automated build](https://registry.hub.docker.com/u/jefferyb/kuali_tomcat/) published to the public [Docker Hub Registry](https://registry.hub.docker.com/).

### Base Docker Image

* [ubuntu](https://registry.hub.docker.com/_/ubuntu)

### Installation

1) Install [Docker](https://www.docker.com/).

2) For Database, download [automated build](https://registry.hub.docker.com/u/jefferyb/kuali_db_mysql/) from public [Docker Hub Registry](https://registry.hub.docker.com/): 

    docker pull jefferyb/kuali_db_mysql

   (alternatively, you can build an image from Dockerfile: 

    docker build -t="jefferyb/kuali_db_mysql" github.com/jefferyb/https://github.com/jefferyb/docker-mysql-kuali-coeus)

3) Download [automated build](https://registry.hub.docker.com/u/jefferyb/kuali_tomcat/) from public [Docker Hub Registry](https://registry.hub.docker.com/): 

    docker pull jefferyb/kuali_tomcat

   (alternatively, you can build an image from Dockerfile: 

    docker build -t="jefferyb/kuali_tomcat" github.com/jefferyb/https://github.com/jefferyb/docker-tomcat-kuali-coeus)


### Usage

#### Run `kuali_db_mysql` database so you can link it with `kuali_tomcat`

    docker run -d --name kuali_db_mysql -h kuali_db_mysql -p 43306:3306 jefferyb/kuali_db_mysql

#### Run `kuali_tomcat`

    docker run -d --name kuali_tomcat -h EXAMPLE.COM --link kuali_db_mysql:kuali_db_mysql -p 8080:8080 jefferyb/kuali_tomcat

Where EXAMPLE.COM is the fqdn of host machine of the docker.

#### Access Kuali Coeus

To access the Kuali Coeus instance, go to:

    http://EXAMPLE.COM:8080/kc-dev

Where EXAMPLE.COM is what you set the "-h EXAMPLE.COM" when running `kuali_tomcat`

#### Connect to Docker container

To get into the docker image, do:

    docker exec -it kuali_tomcat bash

