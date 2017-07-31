
sudo chkconfig elasticsearch on

sudo systemctl start elasticsearch

cmd="curl -XGET "$ELASTICSEARCH_URL"/_cat/health"; for i in {1..6}; do if $cmd; then echo "OK"; break; else echo "Retrying $i"; sleep 10; fi; if [ $i = 5 ]; then echo "FAILED"; exit 1; fi done
