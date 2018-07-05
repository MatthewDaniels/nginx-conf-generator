# <%= siteName %> upstream
upstream <%= upstreamName %> {
  server 127.0.0.1:<%= upstreamPort %> fail_timeout=0;
}

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

  keepalive_timeout 180;
  client_max_body_size 1024M;

  # include global server error pages
  include snippets/globalerrorpage.conf;

  # reverse proxy to docker
  location / {
      # Send traffic to the backend
      proxy_pass http://<%= upstreamName %>;
      proxy_set_header X-Real-IP $remote_addr;
      proxy_set_header X-Forwarded-for $proxy_add_x_forwarded_for;
      proxy_set_header Host $http_host;
      proxy_set_header X-Forwarded-Proto $scheme;
      proxy_set_header X-Forwarded-Protocol $scheme;
      proxy_redirect off;

      # Send websocket data to the backend as well
      proxy_http_version 1.1;
      proxy_set_header Upgrade $http_upgrade;
      proxy_set_header Connection "upgrade";

      allow all;
  }

  location = /favicon.ico { access_log off; log_not_found off; }
  location = /robots.txt  { access_log off; log_not_found off; }

  access_log /var/log/nginx/<%= accessLogName %>-access.log;
  error_log  /var/log/nginx/<%= errorLogName  %>-error.log error;
}