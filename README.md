# Sinputer's Site

Personal writing published from Markdown with the `minimal` theme from
[jekyll-obsidian](https://github.com/wowfun/jekyll-obsidian).

- Authored content lives in `content/`.
- The replaceable publishing workspace lives in `website/`.
- Host configuration lives in `.github/jekyll-obsidian.yml`.

## Local development

```sh
website/bin/setup
website/bin/dev
```

Run the same checks used by the generated Pages workflow with:

```sh
(cd website && npx playwright install chromium)
website/bin/integrate --check
RUN_BROWSER_TESTS=1 website/bin/test
JEKYLL_ENV=production website/bin/build \
  --url https://sinputer.top \
  --baseurl "" \
  --destination _site-production
```

## Publishing

`.github/workflows/pages.yml` verifies and deploys the site through GitHub
Actions. The custom domain is managed in GitHub Pages settings; this repository
does not publish a legacy `CNAME`, service worker, web app manifest, or offline
fallback.
