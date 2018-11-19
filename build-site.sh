#!/bin/bash

# Build the blog
hugo

# Allow RSS to be accessed simply as /feed
cp -av public/feed/index.xml public/feed/index.html
