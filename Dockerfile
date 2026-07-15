FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app
COPY . .
RUN mvn clean package -DskipTests

FROM tomcat:10.1-jdk17
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/target/jcart-ecommerce-project.war /usr/local/tomcat/webapps/ROOT.war

# Owner-uploaded product images are saved to <user.home>/jcart-uploads
# (root's home inside this image = /root/jcart-uploads). Mount a volume here
# so uploaded images survive container rebuilds/restarts, e.g.:
#   docker run -v jcart-uploads:/root/jcart-uploads -p 8080:8080 <image>
VOLUME ["/root/jcart-uploads"]

EXPOSE 8080
