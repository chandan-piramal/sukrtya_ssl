# Stage 1: Build
FROM maven:3.9.4-openjdk-17 AS build

# Set the working directory in the container
WORKDIR /app

# Copy only the Maven project descriptor files to leverage Docker cache
COPY pom.xml .

# Resolve Maven dependencies
RUN mvn dependency:resolve

# Copy the entire project into the container
COPY . .

# Build the project
RUN mvn clean package -DskipTests

# Stage 2: Run
FROM openjdk:17-jdk-slim

# Set the working directory in the container
WORKDIR /app

# Expose the application port
EXPOSE 8080

# Copy the built JAR file from the build stage
COPY --from=build /app/target/*.jar app.jar

# Run the application
ENTRYPOINT ["java", "-jar", "app.jar"]
