FROM docker.io/library/busybox:1.38.0@sha256:a46257e06c82ad85242d0d38077d0a52d9896389ca60a1a59d3463db586e5fa4
RUN adduser -D static
USER static
WORKDIR /home/static
COPY ./public/ /home/static
CMD ["busybox", "httpd", "-f", "-p", "3000"]