

git clone https://github.com/wg/wrk.git

(cd wrk && make)

cp wrk/wrk /usr/local/bin/.

# wrk -t2 -c10 -d120s http://67.205.152.165:9999/hello-world?name=Aidan

# This runs a benchmark for 30 seconds, using 2 threads, and keeping 20 HTTP connections open.

