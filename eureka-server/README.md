
                                           # Steps
1. https://start.spring.io/   ---> create a eureka-server  (discovery-server)

                                            ### MAVEN ###
2. Compile with Maven and created a JAR File.
docker run -it --rm --name my-maven-project -v "$(pwd)"/discovery-server:/usr/src/mymaven -w /usr/src/mymaven maven:latest mvn clean package

                                          ### Dockerfile ###

FROM openjdk:latest
EXPOSE 8761
ADD /target/eureka-server.jar eureka-server.jar
ENTRYPOINT ["java","-jar","eureka-server.jar"]

------------------------------------------> command     docker build .

                                         ###  TAG  ###

------------------------------------------> command docker tag imageid eureka-server

docker run --name eureka-server -p 80:8761 --restart unless-stopped -id eureka-server:latest

