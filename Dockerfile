#
# Kuali Coeus on tomcat Dockerfile
#
# https://github.com/jefferyb/docker-tomcat-kuali-coeus
#
# To Build:
#    docker build -t kuali_tomcat .
#
# To Run:
#    docker run -d --name kuali_db_mysql -h kuali_db_mysql -p 43306:3306 kuali_db_mysql:1504.3
#    docker run -d --name kuali_tomcat -h EXAMPLE.COM --link kuali_db_mysql:kuali_db_mysql -p 8080:8080 kuali_tomcat

# Pull base image.
FROM ubuntu:14.04.2
MAINTAINER Jeffery Bagirimvano <jeffery.rukundo@gmail.com>

# TOMCAT RELATED
ENV TOMCAT_LINK="http://www.eng.lsu.edu/mirrors/apache/tomcat/tomcat-8/v8.0.22/bin/apache-tomcat-8.0.22.tar.gz"
ENV TOMCAT_FILE="apache-tomcat-8.0.22.tar.gz"
ENV TOMCAT_LOCATION="/opt/apache-tomcat/tomcat8"

# MySQL Connector Java
ENV MYSQL_CONNECTOR_LINK="http://mirror.cogentco.com/pub/mysql/Connector-J/mysql-connector-java-5.1.34.zip"
ENV MYSQL_CONNECTOR_ZIP_FILE="mysql-connector-java-5.1.34.zip"
ENV MYSQL_CONNECTOR_FILE="mysql-connector-java-5.1.34/mysql-connector-java-5.1.34-bin.jar"

# Tomcat - Spring Instrumentation
ENV SPRING_INSTRUMENTATION_TOMCAT_LINK="http://central.maven.org/maven2/org/springframework/spring-instrument-tomcat/3.2.12.RELEASE/spring-instrument-tomcat-3.2.12.RELEASE.jar"

# Kuali Release File
ENV KC_CONFIG_XML_LOC="/opt/kuali/main/dev"
ENV KC_WAR_FILE_LINK="http://goo.gl/EvGiWY"

RUN mkdir -p /SetupTomcat

ADD SetupTomcat /SetupTomcat

# Install MySQL.
RUN \
  apt-get update && \
	apt-get install -y wget zip unzip openjdk-7-jdk tar && \
	cd /SetupTomcat  && \
	wget ${TOMCAT_LINK} && \
	mkdir -p ${TOMCAT_LOCATION} && \
	tar --strip-components=1 -zxvf ${TOMCAT_FILE} -C ${TOMCAT_LOCATION} && \
	wget ${MYSQL_CONNECTOR_LINK} && \
	unzip -j ${MYSQL_CONNECTOR_ZIP_FILE} ${MYSQL_CONNECTOR_FILE} -d ${TOMCAT_LOCATION}/lib && \
	cp /SetupTomcat/setenv.sh ${TOMCAT_LOCATION}/bin && \
	cd ${TOMCAT_LOCATION}/lib && \
	wget ${SPRING_INSTRUMENTATION_TOMCAT_LINK} && \
	sed -i 's/<Context>/<Context>\n    <!-- END - For Kuali Coeus - Jeffery B. -->/' ${TOMCAT_LOCATION}/conf/context.xml && \
	sed -i 's/<Context>/<Context>\n    <Loader loaderClass="org.springframework.instrument.classloading.tomcat.TomcatInstrumentableClassLoader"\/>/' ${TOMCAT_LOCATION}/conf/context.xml && \
	sed -i 's/<Context>/<Context>\n\n    <!-- BEGIN - For Kuali Coeus -->/' ${TOMCAT_LOCATION}/conf/context.xml && \
	mkdir -p ${KC_CONFIG_XML_LOC} && \
	cp -f /SetupTomcat/kc-config.xml ${KC_CONFIG_XML_LOC}/kc-config.xml && \
	wget ${KC_WAR_FILE_LINK} -O ${TOMCAT_LOCATION}/webapps/kc-dev.war && \
	rm -fr /SetupTomcat && \
	echo "Done!!!"

# Expose ports.
EXPOSE 8080

# Define default command.
CMD export TERM=vt100; sed -i "s/localhost/$(hostname -f)/" ${KC_CONFIG_XML_LOC}/kc-config.xml; ${TOMCAT_LOCATION}/bin/startup.sh; tailf ${TOMCAT_LOCATION}/logs/catalina.out

