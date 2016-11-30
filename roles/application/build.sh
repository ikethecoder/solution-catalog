
cd $1

export JAVA_HOME=/usr/java/jdk1.8.0_60

mvn install

mvn deploy:deploy-file -Durl=http://localhost:9080/repository/snapshots -Dfile=target/spring-boot-hello-world-1.0-SNAPSHOT.jar -DpomFile=pom.xml -DrepositoryId=remote

