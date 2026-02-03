FROM docker.io/library/busybox:1.37.0@sha256:b3255e7dfbcd10cb367af0d409747d511aeb66dfac98cf30e97e87e4207dd76f
RUN adduser -D static
USER static
WORKDIR /home/static
COPY ./public/ /home/static
CMD ["busybox", "httpd", "-f", "-p", "3000"]