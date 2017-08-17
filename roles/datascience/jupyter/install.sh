
mkdir -p /opt/jupyter-work

git clone https://github.com/mfellner/javascript-notebook.git

(cd javascript-notebook && ./docker.sh build)

(cd javascript-notebook &&  docker create -p 8888:8888 --name jupyter -v /opt/jupyter-work:/home/jovyan/work mfellner/javascript-notebook:latest)

rm -rf javascript-notebook
