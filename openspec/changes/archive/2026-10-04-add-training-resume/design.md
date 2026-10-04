# Design

## Context

- The site is built with Jekyll 4.4 using `jekyll-canvas-theme` (Bootstrap 4 CSS, layouts `default` → `page`). It's built locally and uploaded over FTP, so custom `_plugins/` work; there are no GitHub Pages restrictions.
- The theme's header lists every page that has a `menu_title`, sorted by `menu_order`. Home, About and Blog already use this. `hide_in_menu: hide` keeps a page out of the menu.
- Page content uses kramdown with `{: .container}` attributes (Markdown pages) or a `<div class="container clearfix">` wrapper (HTML pages).
- `_data/resumes/trainer.yml` is exposed as `site.data.resumes.trainer`. Its conventions:
  - translatable text is `{ en: ... }` maps;
  - text may contain inline Markdown;
  - dates are `"YYYY"` / `"YYYY-MM"` strings, and `end: null` means present;
  - many fields are optional or `null`;
  - some sections have entries of different shapes: experience entries use `highlights` / `periods` / `summary` / `roles[]`, and `talks_and_community` items are typed.
- The file is copied in from another repo and must never be edited here (see the spec "Data file is used unchanged").

## Goals / Non-Goals

**Goals:**
- Templates that handle any `trainer.yml` with the same structure, including null or missing optional fields, without changes to the file.
- Translation handled in one place, so adding `es` later only needs a page-language setting plus the data.
- Section partials that a future engineering resume can reuse.

**Non-Goals:**
- Validating the data against a schema (owned by the source-of-truth repo).
- A print or PDF layout, a language switcher, or a hub page for several resumes.
- New CSS frameworks or JavaScript.

## Decisions

### 1. Small Ruby filter plugin instead of pure Liquid
`_plugins/resume_filters.rb` defines three Liquid filters:
- `t(lang)`: takes a translatable map and returns `map[lang] || map["en"]`. If given a plain string it returns it unchanged. If given `nil` it returns `nil`.
- `inline_md`: renders the text with the site's Markdown converter and removes the single wrapping `<p>…</p>`, so the text can sit inside `<li>`, `<span>` and headings.
- `date_range(end)`: formats `"YYYY"` → `2019`, `"YYYY-MM"` → `Dec 2012`, `nil` end → `Present`, joined with an en dash. When start and end are the same, it shows a single date.

*Alternatives:*
- Pure Liquid (`x[lang] | default: x.en` repeated everywhere, plus `split: "-"` month lookups). It's verbose, repetitive and easy to get wrong in about 60 places.
- Liquid's `date` filter. It parses `"2012-12"` unreliably.
- `markdownify | remove: "<p>"`. It also strips paragraphs that are meant to be there.

### 2. Page language from front matter
`resume/training.md` sets `lang: en`, and every template calls `| t: page.lang`. Adding Spanish later means a `resume/es/training.md` with `lang: es`, with no template changes.
*Alternative:* hard-code `.en` everywhere. Simpler now, but every template would need changing later.

### 3. Layout plus one include per section
`_layouts/resume.html` (extends `page`) receives the data through a front-matter key `resume: trainer` (`site.data.resumes[page.resume]`), then includes, in order:
`_includes/resume/{header,numbers,profile,courses,teaching_approach,training_experience,engineering_experience,talks,education,languages}.html`.
Each include is passed the resume object and wraps its whole output in `{% if %}`, so missing sections render nothing.
*Alternative:* one big layout file. Harder to read and not reusable for the engineering resume.

### 4. Optional fields always guarded, unknown values have a fallback
- Every optional field is wrapped in `{% if %}`.
- Experience entries render whichever of `highlights`, `sectors`, `clients`, `periods[].details`, `summary` and `roles[]` are present, in that fixed order.
- `talks_and_community` renders `title`, falling back to `text`, then `venue`, `date` and `link` when present, whatever the `type`.
- Badges show `status_note | t`, falling back to `status`, so a new status value still renders.

### 5. Badges with the existing Bootstrap 4 class
Every course status uses `<span class="badge badge-secondary">`, the same for all statuses (see the spec). No new CSS is needed beyond a small amount of spacing in a `<style>` block or an inline class in the layout, if needed.

### 5a. Courses as a responsive table, clear heading levels
Added after the first visual review, because course areas (h3) and course names (h4) looked too alike.
- Each course area is a `<table class="table courses-table">` with columns Course (name + description), Hours, Status and Materials. Courses without materials show an em dash.
- Below Bootstrap's `md` breakpoint (768px), CSS scoped to `.courses-table` hides the header row and stacks each row into a block. Cells keep their label through a `data-label` attribute, and the em dash is hidden. One piece of markup works for both sizes.
- Section headings (h2) use Canvas's `fancy-title title-bottom-border` (theme-coloured underline). Course area headings use a small uppercase, letter-spaced label style, so the levels are easy to tell apart.

*Alternatives:*
- Two copies of the markup toggled with `d-none d-md-table` / `d-md-none`. No custom CSS, but every course is duplicated.
- A `list-group` for every screen size. Simpler, but the columns don't line up on desktop.
- Bootstrap's `.table` alone, without the `courses-table` class. The stacking CSS would then affect every table on the site.

### 6. Email left out by design
The header include renders `name`, `headline`, `location`, `availability` and `links` only. `basics.email` is never referenced in any template.

### 7. Menu entry through front matter
`resume/training.md` sets `title: "Resume - Training"`, `menu_title: Resume`, `menu_order: 3` and `permalink: /resume/training.html`. Blog's `menu_order` needs checking so that Resume comes right after About. Other pages are only renumbered if there's a clash.

### 8. About page edits stay in Markdown
`about.md` stays kramdown with `{: .container}` paragraphs. The text comes from the about-page spec. The links are absolute external URLs plus `{{ "/resume/training.html" | relative_url }}`.

## Risks / Trade-offs

- [A future `trainer.yml` changes the structure (renamed keys, new sections)] → The page skips the unknown parts and the build doesn't fail, so content can disappear without warning. Mitigation: after each copy, look over the built page. A schema in the source-of-truth repo will catch most of this.
- [`inline_md` removing the wrapping `<p>` could mangle multi-paragraph text] → Only remove it when the output has exactly one paragraph. Otherwise return the HTML unchanged.
- [`markdownify` output differs between kramdown versions] → Use the site's own converter (`site.find_converter_instance(Jekyll::Converters::Markdown)`), which behaves the same way as the rest of the site.
- [Menu order clash with existing pages] → Check every page's `menu_order` while implementing and adjust.

## Migration Plan

Additive content change. Build with `bundle exec jekyll build`, check `_site/resume/training.html` and `_site/about-me.html`, then upload over FTP as usual. To roll back, re-upload the previous build.
