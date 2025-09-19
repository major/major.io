# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview
This is major.io, a personal blog built with Hugo static site generator. The site uses the Congo theme (as a Git submodule) and deploys to GitHub Pages and Cloudflare Workers.

## Essential Commands

### Development
```bash
# Start local development server
hugo server -D

# Build the site (production)
hugo --minify

# Build with Cloudflare Pages environment
./build.sh

# Update Hugo module dependencies
hugo mod get -u
hugo mod tidy
```

### Git Submodules
```bash
# Update Congo theme submodule
git submodule update --remote --merge themes/congo

# Initialize submodules after cloning
git submodule update --init --recursive
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
The configuration is split across multiple files in `/config/_default/`:
- `config.toml` - Core Hugo settings (baseURL, pagination, taxonomies)
- `params.toml` - Theme parameters and site customization (colors, features, social links)
- `markup.toml` - Content rendering settings (code highlighting, goldmark options)
- `menus.en.toml` - Navigation menu structure
- `module.toml` - Hugo version requirements

### Content Organization
- Blog posts are in `/content/posts/` organized by year (2006-2025)
- Each post uses Hugo front matter for metadata
- Special sections: `/content/cv.md` (resume), `/content/icanhazip-com-faq/`, `/content/w5wut/` (ham radio)

### Theme Customization
- Congo theme is installed as a Git submodule at `/themes/congo/`
- Custom layouts override theme defaults in `/layouts/`
- Static assets (images, favicons) in `/static/`

### Deployment Pipeline
- **GitHub Pages**: Primary deployment via `.github/workflows/github_pages.yml`
  - Triggered on pushes to main branch
  - Uses Hugo extended version specified in go.mod
  - Builds and deploys to GitHub Pages

- **Cloudflare Workers**: Alternative deployment
  - Configuration in `wrangler.toml`
  - Custom build script `build.sh` for Cloudflare Pages
  - Supports environment-specific Hugo versions

### Key Integration Points
- **Hugo Version**: Managed via go.mod (currently v0.150.0)
- **Renovate Bot**: Automatically updates dependencies via renovate.json
- **RSS Feeds**: Available at /posts/index.xml with custom configuration
- **Search**: Enabled via params.toml with Fuse.js
- **Dark Mode**: Automatic switching based on system preference

## Important Notes
- Always use Hugo extended version for SCSS compilation
- The Congo theme is a Git submodule - don't modify files directly in themes/congo/
- Posts older than 2020 may have different front matter structure from migration
- The site has been running since 2006 with various migrations from other platforms