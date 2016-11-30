

yum -y install Xvfb

# Xvfb &

yum -y install firefox

# (export DISPLAY=localhost:0.0 && firefox)

yum -y install firefox Xvfb libXfont Xorg

yum -y groupinstall "X Window System" "Desktop" "Fonts" "General Purpose Desktop"

Xvfb :99 -ac -screen 0 1280x1024x24 &

java -jar selenium-server-standalone-2.53.1.jar

export DISPLAY=:99

wget http://selenium-release.storage.googleapis.com/2.53/selenium-server-standalone-2.53.1.jar

nohup java -jar selenium-server-standalone-2.53.1.jar &

wget http://selenium-release.storage.googleapis.com/3.0/selenium-server-standalone-3.0.1.jar


# https://gist.github.com/textarcana/5855427

nohup java -jar selenium-server-standalone-2.53.1.jar -role hub -port 4444 &




cat << EOF > /etc/yum.repos.d/google-chrome.repo
[google-chrome]
name=google-chrome - \$basearch
baseurl=http://dl.google.com/linux/chrome/rpm/stable/\$basearch
enabled=1
gpgcheck=1
gpgkey=https://dl-ssl.google.com/linux/linux_signing_key.pub
EOF

yum -y install google-chrome-stable
yum -y install chromedriver

chromedriver &



