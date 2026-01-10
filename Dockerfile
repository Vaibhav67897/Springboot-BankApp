#----------------------------------
# Stage 1: Build
#----------------------------------

# Maven with Java 17 (Eclipse Temurin - official & maintained)
FROM maven:3.9.9-eclipse-temurin-17-alpine AS builder

# MAINTAINER deprecated → LABEL use karo (warning fix)
LABEL maintainer="Madhup Pandey <madhuppandey2908@gmail.com>"
LABEL app="bankapp"

# Set working directory
WORKDIR /src

# Copy source code from local to container
COPY . /src

# Build application and skip test cases
RUN mvn clean install -DskipTests=true

#--------------------------------------
# Stage 2: Runtime (small image)
#--------------------------------------

# openjdk:17-alpine removed → Eclipse Temurin (official OpenJDK builds)
FROM eclipse-temurin:17-jre-alpine AS deployer

# Copy JAR from builder stage
COPY --from=builder /src/target/*.jar /src/target/bankapp.jar

# Expose application port 
EXPOSE 8080

# Start the application
ENTRYPOINT ["java", "-jar", "/src/target/bankapp.jar"]
