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

## Publishing and upgrades

`.github/workflows/pages.yml` builds with the versioned Jekyll Obsidian Action
and deploys that verified artifact to GitHub Pages. The custom domain is managed
in GitHub Pages settings.

To upgrade, change the exact gem version in `Gemfile` and the matching Action
tag in the workflow, run `bundle update jekyll-obsidian-site`, and commit the
lockfile. Keep both Windows and Linux platforms in the lockfile.
