# {{ siteName }} upstream
upstream {{ upstreamName }} {
    server 127.0.0.1:{{ upstreamPort }} fail_timeout=0;
}

# here is the server for site {{ siteName }}
server {
    listen 80;
    server_name {{ hostname }};

        keepalive_timeout 180;
        client_max_body_size 1024M;

        # include global server error pages
        include snippets/globalerrorpage.conf;

        # reverse proxy to docker
        location / {
                # Send traffic to the backend
                proxy_pass http://{{ upstreamName }};
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
        access_log /var/log/nginx/{{ accessLogName }}-access.log;
        error_log  /var/log/nginx/{{ errorLogName  }}-error.log error;
  }