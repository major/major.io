#!/usr/bin/env python
"""Migrate old wordpress-style slugs to the new style."""
import glob
import json
import os
import time
import yaml

from dateparser import parse as parse_date
import frontmatter

markdown_files = glob.glob("content/oldposts/**/*.md", recursive=True)
for markdown_file in markdown_files:
    post = frontmatter.load(markdown_file)

    # Old posts from wordpress, like /2016/09/21/power-8-to-the-people/
    if "url" in post:
        # Set the alias to the original slug.
        post["aliases"] = [post["url"]]

        # Find the real slug without the date.
        slug = post["url"].strip("/").split("/")[-1]

        # Delete the old URL.
        del post["url"]

        # Rename the file to remove the date.
        rename_file = f"{os.path.dirname(markdown_file)}/{slug}.md"

    # Newer posts from hugo without the date in the slug.
    elif "slug" in post:
        rename_file = None

        # Some posts have a timestamp that is a datetime object already, but some don't.
        post_date = post["date"]
        if type(post_date) == str:
            post_date = parse_date(post["date"])

        # Set the alias.
        slug_date = post_date.strftime("%Y/%m/%d")
        post["aliases"] = [f"/{slug_date}/{post['slug']}/"]

        # Rename the file to remove the date.
        rename_file = f"{os.path.dirname(markdown_file)}/{post['slug']}.md"

        # Slug is no longer needed.
        del post["slug"]

    # Newest posts in bundle format.
    elif markdown_file.endswith("index.md"):
        rename_file = None

        post_date = parse_date(post["date"])

        # Get the slug from the directory name holding the markdown file.
        slug = os.path.basename(os.path.dirname(markdown_file))

        # Set the alias.
        slug_date = post_date.strftime("%Y/%m/%d")
        post["aliases"] = [f"/{slug_date}/{slug}/"]

    with open(markdown_file, "w") as fileh:
        fileh.write(frontmatter.dumps(post))

    if rename_file is not None:
        print(f"🚨 Rename: {markdown_file} -> {rename_file}")
        os.rename(markdown_file, rename_file)
