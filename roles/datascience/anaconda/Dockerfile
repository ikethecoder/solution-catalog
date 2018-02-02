FROM continuumio/anaconda3

RUN /opt/conda/bin/conda install jupyter -y --quiet

RUN conda create -n ipykernel_py2 python=2 ipykernel
RUN /bin/bash -c "source activate ipykernel_py2"
RUN python -m ipykernel install --user

# Ruby Kernel / Build czmq
RUN apt-get -y install libtool libffi-dev ruby ruby-dev make
RUN apt-get -y install git libzmq-dev autoconf pkg-config
RUN git clone https://github.com/zeromq/czmq
RUN (cd czmq && ./autogen.sh && ./configure && make && make install)

# Ruby Kernel / Install Ruby libraries
RUN apt-get -y install libtool libffi-dev ruby ruby-dev make
RUN apt-get -y install libzmq3-dev
RUN apt-get -y install ruby
RUN gem install cztop iruby
RUN iruby register --force

RUN gem install canzea

CMD /opt/conda/bin/jupyter notebook --notebook-dir=/opt/notebooks --ip='*' --port=8888 --no-browser --allow-root
