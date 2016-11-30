

ps -eo rss,pid,euser,args:100 --sort %mem | awk '{printf $1/1024 "MB"; $1=""; print }'

