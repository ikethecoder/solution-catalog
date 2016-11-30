

docker run -t -i centos /bin/bash
# Has an ID
# Run all the installation stuff below

# cec0fef83b8d

docker commit -m "R3.2" -a "ikemaster" cec0fef83b8d ike/base

# returned: d1d23609d370906a6879443acf160d338bc092bd2813681b24e40cefb22e5248

docker save -o ike.img ike/base

chmod -w ike.img

docker rmi ike/base

docker load -i ike.img

docker run --name shit -d ike/base
# 8cbcb8bfebfd53898f136e2dd6ff7274790a0782538c1fcf0383023d375b67e4


yum -y install git

cd
git clone https://IKE_CI:55665566@gitlab.com/ikethecoder/ike-environments.git

find /root/ike-environments -name "*.sh" -exec chmod +x {} +
find /root/ike-environments -name "ike" -exec chmod +x {} +

export PATH=$PATH:`realpath ~/ike-environments/environment/production/init`

/root/ike-environments/environment/production/roles/workarounds/ruby/install.sh



------


FROM ike/base
VOLUME /tmp
ADD gs-spring-boot-docker-0.1.0.jar app.jar
RUN sh -c 'touch /app.jar'
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]


docker build -f a .
# Successfully built: 631e22d2f663

docker save -o ike2.img 631e22d2f663

docker run --name shit -d 631e22d2f663
