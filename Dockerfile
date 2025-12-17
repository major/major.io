FROM docker.io/library/busybox:1.37.0@sha256:d80cd694d3e9467884fcb94b8ca1e20437d8a501096cdf367a5a1918a34fc2fd
RUN adduser -D static
USER static
WORKDIR /home/static
COPY ./public/ /home/static
CMD ["busybox", "httpd", "-f", "-p", "3000"]