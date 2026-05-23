FROM docker.io/library/busybox:1.37.0@sha256:0d3f1e630be52ade0c06107515937607be2cab11a2ad2122099fc79e19bcc18b
RUN adduser -D static
USER static
WORKDIR /home/static
COPY ./public/ /home/static
CMD ["busybox", "httpd", "-f", "-p", "3000"]