yes | cp -f roles/ai/rasa-trainer/config/rasa_trainer.service /etc/systemd/system/multi-user.target.wants/.

systemctl daemon-reload

systemctl restart rasa_trainer
