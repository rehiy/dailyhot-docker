FROM node:22-alpine AS builder
RUN apk add --no-cache ca-certificates && npm install --global pnpm@9.15.9
COPY versions.env /tmp/versions.env
COPY initfs/deploy /tmp/deploy
RUN sh /tmp/deploy

FROM node:22-alpine
LABEL maintainer="wang@rehiy.com"
ENV APP_ICP="" \
    APP_COPYRIGHT=Example \
    APP_COPYRIGHT_URL=http://www.example.org \
    NODE_ENV=docker

RUN apk add --no-cache nginx redis bash tini \
    && mkdir -p /var/www/api/logs /run/nginx
COPY --from=builder /var/www/api /var/www/api
COPY --from=builder /var/www/front /var/www/front
COPY initfs/nginx.conf /etc/nginx/http.d/default.conf
COPY --chmod=755 initfs/entrypoint /sbin/entrypoint
WORKDIR /var/www/api
EXPOSE 80
ENTRYPOINT ["/sbin/tini", "--", "/sbin/entrypoint"]
