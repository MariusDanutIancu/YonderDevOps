[Unit]
Description="daemon for node app"

[Service]
Environment=API_KEY={{ api_key }}
WorkingDirectory=/mnt/
ExecStart={{node_path.stdout}} /mnt/app.js
Restart=always

[Install]
WantedBy=multi-user.target