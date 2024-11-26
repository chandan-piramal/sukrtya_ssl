# Stage 1: Build
FROM ubuntu:latest AS build

# Update package manager and install Java 17
RUN apt-get update && apt-get install -y openjdk-17-jdk wget unzip

# Copy project files
WORKDIR /app
COPY . .

# Ensure Gradle wrapper is executable and build the jar
RUN chmod +x ./gradlew
RUN ./gradlew bootJar --no-daemon

# Stage 2: Run
FROM openjdk:17-jdk-slim

# Set the working directory
WORKDIR /app

# Expose the application port
EXPOSE 8080

# Copy the built JAR file from the build stage
COPY --from=build /app/build/libs/*.jar app.jar

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
