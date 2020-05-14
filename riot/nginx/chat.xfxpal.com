server {
    # Host configuration
    listen 80;
    listen [::]:80;
    server_name chat.xfxpal.com;

    location / {
        return 301 https://$host$request_uri;
    }
}

server {
    # Host configuration
    listen 443 http2 ssl;
    listen [::]:443 http2 ssl;
    server_name chat.xfxpal.com;

    # SSL configuration
    # Copy from https://ssl-config.mozilla.org/

    # Keys
    ssl_certificate /etc/letsencrypt/live/chat.xfxpal.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/chat.xfxpal.com/privkey.pem;

    location / {
        proxy_pass http://127.0.0.1:8002;
        proxy_set_header X-Forwarded-Ssl on;
        proxy_redirect off;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-Host $host;
        proxy_set_header X-Forwarded-Server $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarder-For $proxy_add_x_forwarded_for;
        proxy_http_version 1.1;
        proxy_set_header Connection "";
        client_max_body_size 0;
        proxy_read_timeout 3600s;
    }
}
