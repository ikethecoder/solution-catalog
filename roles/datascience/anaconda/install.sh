
docker pull continuumio/anaconda3

(cd roles/datascience/anaconda && docker build --tag local_anaconda .)

docker create -p 8889:8888 -v /var/local/notebooks:/opt/notebooks --name anaconda local_anaconda

