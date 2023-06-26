#!/usr/bin/env python
"""Remove disqus thread ids from posts."""
from glob import glob

import frontmatter

markdown_files = glob(f"content/posts/**/index.md", recursive=True)
print(markdown_files)
for markdown_file in markdown_files:
    post = frontmatter.load(markdown_file)

    print(markdown_file)

    if "dsq_thread_id" in post:
        del post["dsq_thread_id"]
        with open(markdown_file, "w") as fileh:
            fileh.write(frontmatter.dumps(post))
