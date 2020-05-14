server {
    # Host configuration
    listen 80;
    listen [::]:80;
    server_name matrix.xfxpal.com;

    location / {
        return 301 https://$host$request_uri;
    }
}

server {
    # Host configuration
    listen 443 http2 ssl;
    listen [::]:443 http2 ssl;
    server_name matrix.xfxpal.com;

    #access_log /var/log/nginx/matrix.access.log;
    #error_log /var/log/nginx/matrix.error.log;

    # SSL configuration
    # Copy from

    # Keys
    ssl_certificate /etc/letsencrypt/live/matrix.xfxpal.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/matrix.xfxpal.com/privkey.pem;

    location / {
        proxy_pass http://localhost:8008;
        proxy_set_header X-Forwarded-For $remote_addr;
    }
}

server {
    # Host configuration
    listen 8448 http2 ssl; 
    listen [::]:8448 http2 ssl;
    server_name matrix.xfxpal.com;
    
    #access_log /var/log/nginx/matrix.access.log;
    #error_log /var/log/nginx/matrix.error.log;
    
    # SSL configuration
    # Copy from
    
    # Keys
    ssl_certificate /etc/letsencrypt/live/matrix.xfxpal.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/matrix.xfxpal.com/privkey.pem;
    
    location / {
        proxy_pass http://localhost:8008;
        proxy_set_header X-Forwarded-For $remote_addr;
    }   
}   

