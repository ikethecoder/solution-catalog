# Make available in a registry
# Copy to server
# Configure service
# Start service

# Enable on load balancer


# java -Dserver.port=800 -jar target/SampleMicroService-1.0-SNAPSHOT.jar

cp Files/etc/systemd/system/multi-user.target.wants/ike-metadata.service /etc/systemd/system/multi-user.target.wants/.
systemctl daemon-reload
systemctl restart ike-metadata

