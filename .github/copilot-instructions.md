# Copilot instructions for this repository

## Build, test, and lint commands

### Local Ruby/Jekyll workflow
- Project Ruby is pinned to `3.4.9` (`mise.toml` + `Gemfile`), so prefer running commands via `mise exec -- ...` if your shell is not already using that version.
- Install dependencies: `bundle install`  
  (Forestry uses `bundle install --path vendor/bundle`.)
- Run the site locally: `bundle exec jekyll serve`
- Build static output: `bundle exec jekyll build`

### Docker workflow
- Start local development server with Docker Compose: `docker-compose up`  
  (container command runs `bundle exec jekyll serve`)

### Tests and linting
- There is no repository test suite configured (no test runner or test directories).
- There is no lint command configured in this repository.
- There is no single-test command available.

## High-level architecture

- This is a Jekyll site driven by Markdown/HTML content plus front matter.
- The global rendering setup is in `_config.yml`, which selects the `jekyll-canvas-theme` theme and enables `jekyll-feed`, `jekyll_picture_tag`, and `jekyll-seo-tag`.
- Main page content lives in root-level pages (`index.md`, `blog.html`, `categories.html`, `about.md`, `cookies-policy.html`) and blog posts in `_posts/`.
- Theme behavior is customized through `_includes/` overrides:
  - `myhead.html` (SEO/feed/styles + optional analytics include),
  - `footer_widgets.html` (menu + social/contact widgets),
  - `footer_scripts.html` and `assets/js/klaro_config.js` (cookie-consent-managed scripts),
  - picture-tag presets used by `jekyll_picture_tag`.
- `index.md` is not a simple landing page: it renders a custom “recent posts” grid, slicing `site.posts` by `site.tiles_count` from `_config.yml`.
- Docker-based local development is first-class: `Dockerfile` + `docker-compose.yml` define the runtime and mount sibling theme directories (`../jekyll-fssio-theme`, `../jekyll-canvas-theme`) for local theme development.

## Key conventions in this codebase

- **Menu metadata drives navigation:** pages use front matter keys like `menu_title`, `menu_order`, and `hide_in_menu` (string value `"hide"`). Templates read these values when rendering menu links.
- **Post front matter shape is important:** posts commonly define `categories` (YAML list), `excerpt`, `cover_image`, `cover_image_alt`, and `image`. Home/blog templates rely on these keys for cards and previews.
- **Images are expected under `assets/images/` and rendered responsively:** templates use `{% picture %}` with presets in `_data/picture.yml` and a local post header override.
- **`jekyll_picture_tag` dependency is direct:** use the Rubygems dependency declared in `Gemfile`; there is no vendored or submodule copy in `vendor/`.
- **Cookie/analytics scripts are consent-gated:** scripts in `footer_scripts.html` are declared with `type="text/plain"` and app names that match entries in `assets/js/klaro_config.js`.
