user  nginx;
worker_processes  1;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;


events
{
    worker_connections  1024;
}


http
{
    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    log_format  main    '$remote_addr - $remote_user [$time_local] "$request" '
				        '$status $body_bytes_sent "$http_referer" '
				        '"$http_user_agent" "$http_x_forwarded_for"';

    access_log          /var/log/nginx/access.log  main;

    sendfile            on;
    keepalive_timeout   65;

    server
    {
        listen			80;
        server_name		localhost;

        # HTTPS redirect
        return 301 https://$host$request_uri;
    }

    server
    {
        listen              443 ssl;
        server_name	        localhost;

        ssl_certificate     /data/container/ssl/proxy.crt;
        ssl_certificate_key /data/container/ssl/proxy.key;

            # root location
            location /
            {
                # redirect to Startpage
                return 301 https://$host/start;
            }

            # start page
            location /start
            {
                root /opt/www;
            }

        # reverse proxy configuration
        {% for location in locations %}
            location {{ location.location }}
            {
                resolver                127.0.0.11;
                proxy_set_header        Host $host;
                proxy_set_header        X-Real-IP $remote_addr;
                proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_set_header        X-Forwarded-Proto $scheme;

                set $upstream_host {{ location.url }};
                {% if location.trailing_slash %}
                rewrite ^{{ location.location }}(.*) /$1 break;
                {% endif %}
                proxy_pass $upstream_host;
            }
        {% endfor %}

    }

}

