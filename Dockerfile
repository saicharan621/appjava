# Stage 1: Build the application with Maven
FROM maven:3.8.3-openjdk-11-slim AS build
WORKDIR /app
COPY . .
RUN mvn clean install

# Stage 2: Create the final image with the built JAR file
FROM openjdk:11.0
WORKDIR /app
COPY --from=build /app/target/Uber.jar /app/
EXPOSE 9090
CMD ["java", "-jar", "Uber.jar"]
