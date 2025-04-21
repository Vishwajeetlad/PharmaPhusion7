# Start from an official Tomcat base image
FROM tomcat:9.0-jdk11-openjdk

# Optional: Clean default webapps (like ROOT, examples)
# RUN rm -rf /usr/local/tomcat/webapps/*

# Copy your WAR file into Tomcat’s webapps folder
COPY PharmaManagementSystem.war /usr/local/tomcat/webapps/PharmaManagementSystem.war

# Expose port 8081 (Tomcat default)
EXPOSE 8081

# Run Tomcat server
CMD ["catalina.sh", "run"]
