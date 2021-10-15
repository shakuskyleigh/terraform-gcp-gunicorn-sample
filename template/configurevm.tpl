#!/bin/bash
set -e
echo "*****    Installing nginx    *****"
sudo apt update
sudo apt install -y nginx
sudo ufw allow '${ufw_allow_nginx}'

echo "*****    Installing Docker    *****"
sudo apt install docker.io -y

echo "*****    Sketchy Gunicorn Setup    *****"
sudo mkdir app
cd app

cat << EOF >  Dockerfile
FROM alpine:3.14

RUN apk update
RUN apk add --no-cache python3 py3-pip
RUN pip install gunicorn

COPY . /myapp
WORKDIR /myapp

EXPOSE 8000

CMD ["gunicorn" , "-b", "0.0.0.0:8000", "myapp:app"]
EOF

cat << EOF >  myapp.py
def app(environ, start_response):
    data = b"<h1>Hello World</h1>."
    start_response("200 OK", [
        ("Content-Type", "text/html"),
        ("Content-Length", str(len(data)))
    ])
    return iter([data])
EOF

echo "*****  Docker build & Run   *****"
sudo docker build -t gunicorn/hello-world .
sudo docker run -d -p 8000:8000 gunicorn/hello-world

echo "*****   Sketchy nginx configuration   *****"
cat << EOF >  /etc/nginx/sites-enabled/default
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        location / {
            proxy_pass http://127.0.0.1:8000;
        }
}
EOF

echo "*****   Start nginx  *****"
sudo systemctl enable nginx
sudo systemctl restart nginx

echo "*****   Startup script completes!!    *****"
