FROM ruby:2.4.2-jessie

RUN apt-get update

RUN gem install cri -v 2.4.1
RUN gem install canzea -v 0.1.148

RUN apt-get install unzip

RUN canzea --reset

RUN mkdir -p /opt/cloud-profile

RUN canzea --lifecycle=install --role=provisioning --solution=terraform

RUN canzea --lifecycle=install --role=workarounds --solution=canzea

RUN gem install xml-simple java-properties

CMD ["bash"]
