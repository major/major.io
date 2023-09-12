#!/bin/bash
# Build the site properly in Cloudflare pages.
set -euxo pipefail

BRANCH=${CF_PAGES_BRANCH:-main}

if [[ $BRANCH == "main" ]]; then
    # build using the public url
    hugo -b https://major.io
else
    # build using cloudflare's temporary url
    hugo -b $CF_PAGES_URL
fi
