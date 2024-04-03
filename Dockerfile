FROM docker.io/library/busybox:1.36.1
RUN adduser -D static
USER static
WORKDIR /home/static
COPY ./public/ /home/static
CMD ["busybox", "httpd", "-f", "-v", "-p", "3000"]