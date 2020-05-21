server {
    # Host configuration
    listen 80;
    listen [::]:80;
    server_name xfxpal.com;

    location / {
        return 301 https://$host$request_uri;
    }
}

server {
    # Host configuration
    listen 80;
    listen [::]:80;
    server_name www.xfxpal.com;

    location / {
        return 301 https://xfxpal.com$request_uri;
    }
}

server {
    # Host configuration
    listen 443 http2 ssl;
    listen [::]:443 http2 ssl;
    server_name www.xfxpal.com;

    location / {
        return 301 https://xfxpal.com$request_uri;
    }

    ssl_certificate /etc/letsencrypt/live/www.xfxpal.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/www.xfxpal.com/privkey.pem;
}


server {
    # Host configuration
    listen 443 http2 ssl;
    listen [::]:443 http2 ssl;
    server_name xfxpal.com;

    # SSL configuration
    # Copy from

    # Keys
    ssl_certificate /etc/letsencrypt/live/xfxpal.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/xfxpal.com/privkey.pem;

    root /apps/xfxpal-site/xfxpal-talent/build;

    location /videos {
        index index.php index.html index.htm;
        alias /apps/xfxpal-videos;

        location ~ \.php$ {
            fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
            include fastcgi_params;                       
            fastcgi_param SCRIPT_FILENAME $request_filename;
            #fastcgi_intercept_errors on;
        }
    }

    location / {
        index index.html;
    }

    location /_matrix {
        proxy_pass http://localhost:8008;
        proxy_set_header X-Forwarded-For $remote_addr;
    }

    location /.well-known {
        proxy_pass http://localhost:8008;
        proxy_set_header X-Forwarded-For $remote_addr;
    }

}

server {
    # Host configuration
    listen 8448 http2 ssl; 
    listen [::]:8448 http2 ssl;
    server_name xfxpal.com;
    
    # SSL configuration
    # Copy from
    
    # Keys
    ssl_certificate /etc/letsencrypt/live/xfxpal.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/xfxpal.com/privkey.pem;

    location / {
        proxy_pass http://localhost:8008;
        proxy_set_header X-Forwarded-For $remote_addr;
    }   
}   

