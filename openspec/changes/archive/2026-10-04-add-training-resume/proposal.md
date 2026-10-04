# Proposal

## Why

The site has no resume, and the only mention of training is a single line on the About page that makes it look like a side activity, even though I have been training IT teams for more than twenty years. I'm now open to new opportunities, so visitors (training clients and hiring managers) need a clear, up-to-date view of what I teach and what I've done. The About page is also out of date: it still says I work at Platform161. (GitHub issue #49.)

## What Changes

- Add a **Resume - Training** page at `/resume/training.html`, rendered from the structured data file `_data/resumes/trainer.yml`.
- Add a **Resume** entry to the main menu that links to the training resume.
- `trainer.yml` is maintained in a separate source-of-truth repository and copied into this repo unchanged. The page has to render whatever that file contains, and nothing in this repo edits the file.
- The page shows the profile, key numbers, courses (each with a status badge, all styled the same), teaching approach, training experience, full engineering experience, talks and community, education and languages. It does **not** show the email address.
- English only for now. The page reads the `en` text and is built so that more languages can be added later without changing its templates.
- Rewrite parts of the About page:
  - Replace the "Who I am" text with a short, plain introduction (a placeholder until a later change reworks it).
  - Rewrite "What I do for a living": training first, with a link to the resume; earlier engineering roles; Platform161 (now part of Verve) and RubiconMD (now part of CVS Health) in chronological order with the resume's job titles; and a line saying I'm open to new opportunities.
  - Update the pets paragraph (a dog and three cats) and fix its typos.

Out of scope: a print layout, PDF generation (handled in the source-of-truth repo), a JSON schema for the data, keeping the two repos in sync, Spanish translations, a contact page, and an engineering resume.

## Capabilities

### New Capabilities
- `training-resume`: a public page that renders the training resume from the structured data file, reachable from the main menu.
- `about-page`: the About page content, covering who I am, what I do for a living (with a link to the resume) and personal details.

### Modified Capabilities
<!-- None: no existing specs. -->

## Impact

- New: `resume/training.md`, `_layouts/resume.html`, `_includes/resume/*.html`, `_plugins/resume_filters.rb` (Liquid filters for picking the translated text, rendering inline Markdown and formatting date ranges).
- Existing: `_data/resumes/trainer.yml` (already added, read-only), `about.md` (rewritten sections).
- The site menu gains a "Resume" entry, through the theme's existing `menu_title`/`menu_order` mechanism.
- No new gem dependencies. Custom plugins work because the site is built locally and uploaded over FTP, not built by GitHub Pages.
