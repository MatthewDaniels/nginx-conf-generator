
# server config for <%= siteName %>
server {
    listen 80;
    <% if(typeof(isSSL) !== "undefined") { %>
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    server_name <%= hostname %>;

    ssl on;
    ssl_certificate           /etc/letsencrypt/live/<%= hostname.split(' ')[0] %>/fullchain.pem;
    ssl_certificate_key       /etc/letsencrypt/live/<%= hostname.split(' ')[0] %>/privkey.pem;


    # Here we define the web-root for our SSL proof
    location /.well-known {
      # Note that a request for /.well-known/test.html will
      # look for /var/www/ssl-proof/<%= hostname.split(' ')[0] %>/.well-known/test.html
      # and not /var/www/ssl-proof/<%= hostname.split(' ')[0] %>/test.html
      root /var/www/ssl-proof/<%= hostname.split(' ')[0] %>/;
    }

    <% } %>

    client_max_body_size 1024M;
    keepalive_timeout 180;
    fastcgi_read_timeout 960;

    root <%= rootPath %>;
    index index.html index.htm;

    # Make site accessible from http://<%= hostname %>/
    server_name <%= hostname %>;

    location / {
        # First attempt to serve request as file, then
        # as directory, then fall back to displaying a 404.
        try_files $uri $uri/ =404;
    }

    # no php access - just in case it exists
    location ~ \.php$ {
           deny all;
    }

    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    location ~ /\.ht {
           deny all;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    access_log /var/log/nginx/<%= accessLogName %>-access.log;
    error_log  /var/log/nginx/<%= errorLogName  %>-error.log error;
}
