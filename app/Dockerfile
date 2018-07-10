FROM centos:centos7
MAINTAINER Fernando J. Pando <nando@hex7.com>

RUN yum -y install epel-release
RUN yum -y install nginx

RUN ln -sfv /dev/stdout /var/log/nginx/access.log
RUN ln -sfv /dev/stdout /var/log/nginx/error.log

COPY index.html /usr/share/nginx/html/index.html
COPY stelligent.jpg /usr/share/nginx/html/stelligent.jpg

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
