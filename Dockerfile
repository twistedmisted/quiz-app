#
# Build stage
#
FROM maven:3.6.3-openjdk-17 AS build
COPY src /home/app/src
COPY pom.xml /home/app
RUN mvn -f /home/app/pom.xml clean -DskipTests=true package

#
# Deploy stage
#
FROM tomcat:10
COPY /certs/keystore.jks /certs/keystore.jks
COPY /certs/SSLConfig.properties /certs/SSLConfig.properties
ENV CATALINA_OPTS="-Dcom.intersystems.SSLConfigFile=/certs/SSLConfig.properties"
COPY --from=build /home/app/target/main_project-1.0-SNAPSHOT.war /usr/local/tomcat/webapps/ROOT.war