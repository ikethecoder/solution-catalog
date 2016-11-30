
# https://taigaio.github.io/taiga-doc/dist/setup-production.html

# https://taiga.io/

######################################################################
## Build Taiga backend
######################################################################

useradd taiga

su taiga -l -c "git clone https://github.com/taigaio/taiga-back.git taiga-back"

su taiga -l -c "(cd ~/taiga-back && git checkout stable)"

# (cd ~/taiga-back && pip install --upgrade virtualenv)
# (cd ~/taiga-back && pip install six)


su taiga -l -c "(export WORKON_HOME=~/.virtualenvs && source /usr/bin/virtualenvwrapper.sh)"

su taiga -l -c "(mkvirtualenv -p /opt/python3.5/bin/python3 taiga)"

su taiga -l -c "(cd ~/taiga-back && workon taiga && pip3 install -r requirements.txt)"
