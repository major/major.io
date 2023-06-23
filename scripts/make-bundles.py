#!/usr/bin/env python
"""Turn single markdown files into Hugo bundles."""
from glob import glob
import os
import sys

markdown_path = sys.argv[1]

markdown_files = glob(f"{markdown_path}/*.md")
for markdown_file in markdown_files:
    slug, _ = markdown_file.split(".")

    bundle_dir = f"{markdown_path}/{slug}/"
    os.makedirs(bundle_dir, exist_ok=True)
    os.rename(markdown_file, f"{bundle_dir}/index.md")
