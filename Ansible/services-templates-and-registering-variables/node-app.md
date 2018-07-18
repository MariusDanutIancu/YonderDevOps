[Unit]
Description="daemon for node app"

[Service]
WorkingDirectory=/mnt/
ExecStart={{ which_nodejs.stdout | default('/usr/bin/nodejs') }} {{ node_app_path }}
Restart=always

[Install]
WantedBy=multi-user.target
