# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

**Keep this file updated whenever the project structure, configuration, deployment, or tooling changes.**

## Project Overview
This is major.io, a personal blog built with Hugo static site generator. The site uses the PaperMod theme (as a Hugo module) and deploys to GitHub Pages.

## Essential Commands

### Development
```bash
# Start local development server
hugo server -D

# Build the site (production)
hugo --minify

# Update Hugo module dependencies
hugo mod get -u
hugo mod tidy
```

### Testing & Validation
```bash
# Check for broken links (after building)
hugo --minify && muffet http://localhost:1313

# Validate HTML output
hugo --minify && html-validate public/**/*.html
```

## Architecture & Structure

### Hugo Configuration
The configuration lives in a single `hugo.yaml` file at the project root. It covers core Hugo settings, PaperMod theme parameters, menus, markup options, and module imports.

### Content Organization
- Blog posts are in `/content/posts/` organized by year (2006-2025)
- Each post uses Hugo front matter for metadata
- Special sections: `/content/cv.md` (resume), `/content/icanhazip-com-faq/`, `/content/w5wut/` (ham radio)

### Theme Customization
- PaperMod is imported as a Hugo module (defined in `go.mod` and `hugo.yaml`)
- Custom layouts override theme defaults in `/layouts/`
- Custom CSS in `/assets/css/extended/` (fonts, overrides)
- Static assets (images, favicons) in `/static/`
- Self-hosted fonts (Source Sans 3, Source Code Pro) in `/static/fonts/`

### Deployment Pipeline
- **GitHub Pages**: Deployment via `.github/workflows/github_pages.yml`
  - Triggered on pushes to main branch and daily at 6:00 AM EST
  - Uses Hugo extended version pinned in the workflow (Renovate-managed)
  - Builds and deploys to GitHub Pages

### Key Integration Points
- **Hugo Version**: Pinned in workflow files with Renovate comments for automatic updates
- **Hugo Modules**: Theme managed via `go.mod`, resolved with `hugo mod get -u`
- **Renovate Bot**: Automatically updates dependencies via renovate.json
- **RSS Feeds**: Available at /posts/index.xml with custom configuration
- **Search**: Enabled via hugo.yaml with Fuse.js
- **Dark Mode**: Automatic switching based on system preference

## Important Notes
- Always use Hugo extended version for SCSS compilation
- Do not modify theme files directly; use `/layouts/` overrides and `/assets/css/extended/` for customization
- Posts older than 2020 may have different front matter structure from migration
- The site has been running since 2006 with various migrations from other platforms
