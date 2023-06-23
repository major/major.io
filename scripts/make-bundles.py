#!/usr/bin/env python
"""Turn single markdown files into Hugo bundles."""
from glob import glob
import os
import sys

markdown_path = sys.argv[1]

markdown_files = glob(f"{markdown_path}/*.md")
for markdown_file in markdown_files:
    slug = markdown_file.split("/")[-1].split(".")[0]
    bundle_dir = f"{markdown_path}/{slug}/"
    bundle_file = f"{bundle_dir}/index.md"

    os.makedirs(bundle_dir)
    os.rename(markdown_file, bundle_file)
