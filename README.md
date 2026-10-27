# Sinputer's Site

Personal writing published from Markdown with the `minimal` theme from
[jekyll-obsidian](https://github.com/wowfun/jekyll-obsidian).

- Authored content lives in `content/`.
- Site configuration lives in `.github/jekyll-obsidian.yml`.
- `Gemfile` and `Gemfile.lock` pin the published `jekyll-obsidian-site` gem.

## Local development

Install Ruby 4.0.x, Bundler and Git. On Windows, use RubyInstaller with Devkit
for native gem dependencies.

```sh
bundle install
bundle exec jekyll-obsidian dev
```

The preview is at `http://127.0.0.1:58000/`. Build and audit the production site with:

```sh
bundle exec jekyll-obsidian build
```

Output is written to `.jekyll-obsidian-cache/site/`. The gem includes compiled
frontend assets, so site builds do not need Node.js or a copied theme workspace.

The home page shows the authored introduction and recent posts. Blog entries
are grouped by year. Portfolio, Dao and Favorites remain authored collections;
the browser-local favorites feature is disabled to preserve the Favorites route.

## Footer navigation preview

The shared footer contains the existing GitHub and X contacts, followed by links
to the Jekyll Obsidian documentation site and Feedgarden. Configure these under
`website.contacts` and `website.footer.links`. Each navigation link has a default
HTTPS `url` and an explicit Chinese target in `locale_urls.zh-CN`; sibling-site
URLs keep their own path and language prefix.

The footer API is supported by the pinned 0.3.2 release. To validate both sites
with the published dependency, run from `D:/Projects/feedgarden`:

```powershell
npm run verify:footer -- --personal-site D:/Projects/wowfun.github.io
$preview = Get-Content .local/feedgarden/validation/footer/current.json -Raw | ConvertFrom-Json
npm run site:serve -- --root $preview.builds.'personal-minimal' --baseurl / --port 58000
```

In a second terminal in Feedgarden, read the same `$preview` file and serve
`$preview.builds.'feedgarden-minimal'` with `--baseurl /feedgarden --port 58002`.
The static previews open at `http://127.0.0.1:58000/` and
`http://127.0.0.1:58002/feedgarden/`. Their footer links cross between these local
ports, while Jekyll Obsidian still opens the live docs. Only generated preview
HTML is remapped; source configuration retains production URLs. Rerun the
verifier to pick up later edits. Screenshots and results are saved under
Feedgarden's `.local/feedgarden/validation/footer/run-*/`; neither site's published
dependency, source content or production database is changed by validation.

## Publishing and upgrades

`.github/workflows/pages.yml` builds with the versioned Jekyll Obsidian Action
and deploys that verified artifact to GitHub Pages. The custom domain is managed
in GitHub Pages settings.

To upgrade, change the exact gem version in `Gemfile` and the matching Action
tag in the workflow, run `bundle update jekyll-obsidian-site`, and commit the
lockfile. Keep both Windows and Linux platforms in the lockfile.
