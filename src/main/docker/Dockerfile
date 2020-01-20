FROM java:latest
MAINTAINER  "breddy@nisum.com"
USER root
ENV APPDIR=/data
RUN mkdir $APPDIR
ADD target/spring-petclinic-2.2.0.BUILD-SNAPSHOT.jar $APPDIR
WORKDIR $APPDIR
CMD ["java", "-jar", "spring-petclinic-2.2.0.BUILD-SNAPSHOT.jar"]
ENV http_proxy host:port
ENV https_proxy host:port
EXPOSE 8040