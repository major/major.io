#!/bin/bash
set -eux -o pipefail

hugo version

# Build the blog
hugo --gc --minify

# Allow RSS to be accessed more simply.
mkdir -vp public/feed
cp -av public/index.xml public/feed/index.html
cp -av public/index.xml public/feed/index.xml
