FROM openjdk:8-jdk-alpine
MAINTAINER "breddy@nisum.com"
RUN mkdir $HOME/app
COPY target/* $HOME/app/
WORKDIR $HOME/app/
ENTRYPOINT ["java","-jar","spring-petclinic-2.2.0.BUILD-SNAPSHOT.jar"]
EXPOSE 8040/tcp