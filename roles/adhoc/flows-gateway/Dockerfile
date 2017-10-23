FROM node:8.7

RUN npm install -g fs

RUN useradd -ms /bin/bash pm2user
RUN groupadd pm2grp
RUN usermod -a -G pm2grp pm2user

USER pm2user
WORKDIR /home/pm2user

RUN mkdir -p flows-gateway

RUN cd flows-gateway && npm install flows-gateway

WORKDIR /home/pm2user/flows-gateway

RUN npm install node-red-contrib-http-request node-red-dashboard node-red-nodes node-red-contrib-graphs node-red-contrib-influxdb node-red-contrib-selenium-webdriver node-red-contrib-bigtimer node-red-contrib-cron node-red-contrib-bigexec node-red-node-mongodb node-red-contrib-postgres node-red-contrib-json-schema node-red-contrib-chatbot node-red-contrib-counter

COPY lib/app.js .

RUN npm install pm2

RUN git clone https://github.com/ikethecoder/node-red-contrib-canzea-elasticsearch.git

RUN npm install ./node-red-contrib-canzea-elasticsearch

RUN git clone https://github.com/ikethecoder/node-red-biglib.git

RUN npm install ./node-red-biglib

COPY lib/config.yml .

# COPY lib/settings.js /home/pm2user/.node-red/settings.js

ENV PORT=8000
ENV NODE_ENV=development

CMD ["node", "app.js"]
