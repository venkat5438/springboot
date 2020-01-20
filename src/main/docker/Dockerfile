FROM java:latest
MAINTAINER  "breddy@nisum.com"
USER root
VOLUME /tmp
WORKDIR /
ADD /target/spring-petclinic-2.2.0.BUILD-SNAPSHOT.jar springboot.jar
ENV http_proxy host:port
ENV https_proxy host:port
EXPOSE 8040
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/springboot.jar"]