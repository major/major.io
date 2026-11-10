# AGENTS.md

## Project shape
- This repo is a Hugo static site for `https://major.io/`; `hugo.yaml` is the source of truth.
- Hugo must be Extended. `.hugo-version` pins the deploy version, while `hugo.yaml` declares the minimum supported version.
- The PaperMod theme is a Hugo module in `go.mod`; the Go module exists for theme/module management, not application code.
- Posts live under `content/posts/` as page bundles like `content/posts/2026/example-slug/index.md`; keep post assets beside `index.md` and use front matter `cover.image` with `cover.relative: true` for bundled images.

## Commands
- Production build matching PR CI: `HUGO_ENVIRONMENT=production HUGO_ENV=production hugo --gc --minify`.
- If only the downloaded CI binary is available, CI runs `./hugo --gc --minify` after fetching Hugo Extended.
- Cloudflare Pages uses `sh scripts/build-cloudflare.sh`; it downloads Hugo Extended from `.hugo-version`, uses `CF_PAGES_URL` as `--baseURL` when present, and writes `public/`.
- There is no repo test, lint, pre-commit, Makefile, justfile, or Taskfile suite. Verify content and theme changes with a Hugo build.

## Build and deploy gotchas
- GitHub Pages deploys daily at 6:17 AM Eastern using `timezone: America/New_York` in `.github/workflows/github_pages.yml`; GitHub can delay scheduled runs.
- `.github/workflows/bunnycdn.yml` restores stock s3deploy v2.16.0 for `https://de-s3.storage.bunnycdn.com` in region `de`. It is manual-only and defaults to a dry run; clear `dry_run` in Run workflow to upload. The existing GitHub Pages deployment is unchanged.
- Bunny uses the GitHub Actions secrets `AWS_ACCESS_KEY_ID` (S3-enabled Storage Zone name, also the bucket) and `AWS_SECRET_ACCESS_KEY` (Storage Zone password). S3 must be enabled when creating the zone. A dry run does not validate uploads: stock s3deploy still sends a default ACL header, which Bunny documents as unsupported.
- `.s3deploy.yml` disables upload-time gzip because Bunny CDN does not yet use stored S3 metadata. Configure compression and cache policy on the Pull Zone, then purge its cache after successful uploads when immediate updates are needed. This workflow does not purge automatically or provide atomic deployment/rollback; s3deploy can delete remote files absent from `public/` (default limit: 256 per deploy).
- Bunny preserves `/feed/index.xml`; configure legacy feed redirects to `/index.xml` on the Pull Zone because Bunny does not interpret `static/_redirects`.
- GitHub Pages deploy builds with `--baseURL` from Pages, then copies `public/index.xml` to `public/feed/index.xml`; keep that RSS compatibility behavior if editing deploy flow.
- `static/_redirects` maps `/feed`, `/feed/rss`, and `/feed/atom` variants to `/index.xml` for hosts that honor Netlify-style redirects.
- `wrangler.jsonc` and the BusyBox `Dockerfile` both expect a prebuilt `public/` directory.
- Generated or local-only paths are ignored: `public/`, `resources/_gen/`, `.hugo_build.lock`, `.wrangler`, `.dev.vars*`, and `.env*`.

## Custom theme surface
- `layouts/_default/rss.xml` overrides PaperMod RSS and emits full post content in `<description>`.
- `layouts/partials/extend_head.html` preloads local fonts from `static/fonts/`.
- PaperMod CSS overrides belong in `assets/css/extended/`; current overrides define local fonts, show cover images on tag pages, and widen `--main-width` to `840px`.

## Maintenance rules
- Update this `AGENTS.md` in the same change whenever substantial site architecture, build, deploy, theme override, content layout, or workflow behavior changes.
- Treat `scripts/make-bundles.py`, `scripts/migrate-slugs.py`, `scripts/move-images.py`, and `scripts/remove-disqus-id.py` as one-off migration utilities. Read them before running because they rename or rewrite content in place.
