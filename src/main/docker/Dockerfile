FROM java:latest
MAINTAINER  "breddy@nisum.com"
USER root
VOLUME /tmp
ADD /target/spring-petclinic-2.2.0.BUILD-SNAPSHOT.jar .
CMD ["java", "-jar", "spring-petclinic-2.2.0.BUILD-SNAPSHOT.jar"]
ENV http_proxy host:port
ENV https_proxy host:port
EXPOSE 8040