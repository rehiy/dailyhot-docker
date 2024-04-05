FROM node:alpine

LABEL version="1.0.5" \
      maintainer="wang@rehiy.com"

ENV APP_ICP=
ENV APP_COPYRIGHT=Example
ENV APP_COPYRIGHT_URL=http://www.example.org

ADD initfs /tmp
RUN sh /tmp/deploy

ENTRYPOINT ["/sbin/entrypoint"]

EXPOSE 80
