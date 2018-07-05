# server config for <%= siteName %>
server {
    listen 80;
    server_name <%= hostname %>;
    <% if(typeof(isSSL) !== "undefined") { %>
    return 301 https://$host$request_uri;
}

server {
    listen 443 ssl http2;
    server_name <%= hostname %>;

    ssl_certificate           /etc/letsencrypt/live/<%= hostname.split(' ')[0] %>/fullchain.pem;
    ssl_certificate_key       /etc/letsencrypt/live/<%= hostname.split(' ')[0] %>/privkey.pem;

    keepalive_timeout 180;
    client_max_body_size 1024M;
    fastcgi_read_timeout 960;

    # Here we define the web-root for our SSL proof
    location /.well-known {
        # Note that a request for /.well-known/test.html will
        # look for /var/www/ssl-proof/<%= hostname.split(' ')[0] %>/.well-known/test.html
        # and not /var/www/ssl-proof/<%= hostname.split(' ')[0] %>/test.html
        root /var/www/ssl-proof/<%= hostname.split(' ')[0] %>/;
    }

    <% } %>

    # todo: custom additions like this
    #include /etc/nginx/conf/coolsite/proxy_pass.conf;


    # include global server error pages
    include snippets/globalerrorpage.conf;

    root <%= rootPath %>;

    index index.php index.html index.htm;

    charset utf-8;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    # Remove trailing slash to please routing system.
    if (!-d $request_filename) {
        rewrite     ^/(.+)/$ /$1 permanent;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    access_log /var/log/nginx/<%= accessLogName %>-access.log;
    error_log  /var/log/nginx/<%= errorLogName  %>-error.log error;

    sendfile off;

  <% if(phpTypeOptions === 'laravel'){ %>
    include /etc/nginx/conf/laravel/default.conf;
  <% } else if(phpTypeOptions === 'wordpress') { %>
    include /etc/nginx/conf/wordpress/global_restrictions.conf;
    include /etc/nginx/conf/wordpress/default.conf;
  <% } else { %>
    # nothing extra to include
  <% } %>

    # deny access to .htaccess
    location ~ /\.ht {
        deny all;
    }

    # todo: ensure this is correct
    allow all;
}
