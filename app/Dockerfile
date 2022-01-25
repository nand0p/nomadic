FROM nginx:alpine
MAINTAINER hexseven <hexseven@nomadic.red>

RUN apk add nginx

#RUN ln -sfv /dev/stdout /var/log/nginx/access.log
#RUN ln -sfv /dev/stdout /var/log/nginx/error.log

COPY index.html /usr/share/nginx/html/index.html
COPY nomadic.png /usr/share/nginx/html/nomadic.png

#CMD ["nginx", "-g", "daemon off;"]
