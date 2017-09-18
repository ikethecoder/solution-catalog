
# https://github.com/ikethecoder/nifi/tree/nifi-3709-2

git clone https://github.com/ikethecoder/nifi.git -b nifi-3709-2

export JAVA_HOME=/usr/java/jdk1.8.0_144

mvn -T 2.0C -DskipTests clean install

tar xzf nifi/nifi-assembly/target/nifi-*-bin.tar.gz -C ~/.

cd ~/nifi-*

./bin/nifi.sh start


# Remote debug

# java -Xdebug -Xrunjdwp:transport=dt_socket,address=8998,server=y -jar myapp.jar

