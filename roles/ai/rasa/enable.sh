yes | cp -f roles/ai/rasa/config/rasa_nlu.service /etc/systemd/system/multi-user.target.wants/.

systemctl daemon-reload

systemctl restart rasa_nlu

