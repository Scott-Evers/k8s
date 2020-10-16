FROM ubuntu

LABEL maintainer="Involta www.involta.com"

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y
RUN apt-get install dialog apt-utils -y
RUN apt-get install curl -y

RUN mkdir /node_services

WORKDIR /node_services

COPY blog_sample_app/data/service.js /node_services/service.js

RUN mkdir /node_services/posts

CMD curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -

RUN apt-get install -y nodejs

EXPOSE 1337/tcp
ENTRYPOINT ["node","service.js"]
# RUN node service.js
