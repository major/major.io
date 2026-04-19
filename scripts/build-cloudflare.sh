#!/bin/sh
#
# Cloudflare Pages build script for major.io
# Reads Hugo version from .hugo-version and builds the site.
#
# Cloudflare Pages dashboard config:
#   Build command: sh scripts/build-cloudflare.sh
#   Build output directory: public
#
set -eu

HUGO_VERSION=$(cat .hugo-version)
HUGO_URL="https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_extended_${HUGO_VERSION}_linux-amd64.tar.gz"

echo "Downloading Hugo extended v${HUGO_VERSION}..."
curl -sL --retry 5 "${HUGO_URL}" | tar xz hugo

echo "Hugo version:"
./hugo version

echo "Building site..."
./hugo --gc --minify
