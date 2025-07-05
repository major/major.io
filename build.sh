#!/bin/bash
# Build the site properly in Cloudflare pages.
set -euxo pipefail

# Get the latest hugo version from the go.mod
LATEST_HUGO_VERSION=$(grep github.com/gohugoio/hugo go.mod | awk '{print $NF}' | sed 's/^v//')
HUGO_DOWNLOAD_URL="https://github.com/gohugoio/hugo/releases/download/v${LATEST_HUGO_VERSION}/hugo_extended_${LATEST_HUGO_VERSION}_linux-amd64.tar.gz"
curl -sL --retry 5 "$HUGO_DOWNLOAD_URL" | tar xvzf - hugo
./hugo version

./hugo --enableGitInfo --minify --cleanDestinationDir --destination public
