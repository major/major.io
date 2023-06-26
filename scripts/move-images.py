#!/usr/bin/env python
"""Move featured images into bundles."""
from glob import glob
import os

import frontmatter

markdown_files = glob(f"content/posts/**/*.md", recursive=True)
for markdown_file in markdown_files:
    slug = markdown_file.split("/")[-1].split(".")[0]
    bundle_dir = os.path.dirname(markdown_file)

    post = frontmatter.load(markdown_file)

    if "images" in post:
        print(markdown_file)
        os.rename(f"static/{post['images'][0]}", f"{bundle_dir}/featured.jpg")

        del post["images"]

        with open(markdown_file, "w") as fileh:
            fileh.write(frontmatter.dumps(post))
