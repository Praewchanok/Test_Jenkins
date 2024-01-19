# Use an official Jenkins base image
FROM jenkins/jenkins:latest

# Switch to root user to install additional tools
USER root

# Install necessary tools and dependencies
RUN apt-get update \
    && apt-get install -y \
        curl \ 
        git \ 
        python3-pip \
    && apt-get clean
# Install the Java Development Kit (JDK), which is required to run Jenkins.
RUN apt-get install -y default-jdk

# Add Jenkins repository key to APT
RUN curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | gpg --dearmor -o /usr/share/keyrings/jenkins-archive-keyring.gpg \
    && echo deb [signed-by=/usr/share/keyrings/jenkins-archive-keyring.gpg] https://pkg.jenkins.io/debian-stable binary/ | tee /etc/apt/sources.list.d/jenkins.list > /dev/null \
    && rm -rf /var/lib/apt/lists/*

# Switch back to the Jenkins user
USER jenkins

# Expose the Jenkins web port
EXPOSE 8080

# Expose the Jenkins agent port (if needed)
EXPOSE 50000

# Start Jenkins on container startup
CMD ["java", "-jar", "/usr/share/jenkins/jenkins.war"]