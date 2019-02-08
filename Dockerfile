FROM fedora:29
RUN echo "fastestmirror=true" >> /etc/dnf/dnf.conf && \
      dnf -y install npm && \
      dnf clean all
RUN npm install -g firebase-tools
RUN wget -q -o hugo.tgz https://github.com/gohugoio/hugo/releases/download/v0.54.0/hugo_0.54.0_Linux-64bit.tar.gz && \
      tar xf hugo.tgz && \
      mv hugo /usr/local/bin/hugo
