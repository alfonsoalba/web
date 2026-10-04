# Tasks

## 1. Filters

- [ ] 1.1 Create `_plugins/resume_filters.rb` with the `t`, `inline_md` and `date_range` filters (design decision 1), and check with a scratch Liquid snippet in a draft page that `t` falls back to `en`, `inline_md` turns `[a](b)` into a link with no `<p>`, and `date_range` formats `"2012-12"`/`nil` as "Dec 2012 – Present" and `"2019"`/`"2022"` as "2019 – 2022"

## 2. Layout and page

- [ ] 2.1 Create `_layouts/resume.html` (extends `page`) that looks up `site.data.resumes[page.resume]` and includes the section partials in the order the spec gives; check that `bundle exec jekyll build` succeeds
- [ ] 2.2 Create `resume/training.md` with `title: "Resume - Training"`, `menu_title: Resume`, `permalink: /resume/training.html`, `lang: en` and `resume: trainer`; check that `_site/resume/training.html` exists after building
- [ ] 2.3 Set `menu_order` so that "Resume" appears right after "About" (today About and Blog are both 2 and Categories is 3; renumber if needed), and check the header menu order in the built HTML

## 3. Section partials (`_includes/resume/`)

- [ ] 3.1 `header.html`: name, headline, location, availability, links, and no email; check that `grep alfonso@alfonsoalba.com _site/resume/training.html` returns nothing
- [ ] 3.2 `numbers.html` (stat tiles) and `profile.html`; check that the four numbers and the profile paragraph render
- [ ] 3.3 `courses.html`: intro, delivery list, areas, then courses with hours, description, materials link and a `badge badge-secondary` status badge (`status_note`, falling back to `status`), plus on-request topics and previously taught; check that all 9 courses render, each with one badge, and that courses with `materials: null` have no link
- [ ] 3.4 `teaching_approach.html`; check that all 5 items render with their titles in bold
- [ ] 3.5 `training_experience.html`: role, organisation (linked when it has a URL, left out when null), location, date range, highlights, sectors, clients, periods with details; check that Cursos de git shows "Dec 2012 – Present" and its 6 clients, and that the freelance entry shows 3 periods and no empty organisation
- [ ] 3.6 `engineering_experience.html`: organisation, location, overall range, every role with its range, highlights or summary; check that RubiconMD lists its 3 roles with dates and that the other 4 companies show their summaries
- [ ] 3.7 `talks.html`: community and publication items show `text` with inline Markdown; talks show title, venue, date and link when present; check that the YouTube link renders as an `<a>` and no literal `[` or `](` appears
- [ ] 3.8 `education.html` and `languages.html`: in-progress items with no year render without an empty year, and certificate links render when present; check in the built page

## 4. About page

- [ ] 4.1 Replace the "Who I am" text in `about.md` with the short option-A introduction; check that the page has no Matrix, Morpheus or red-pill text
- [ ] 4.2 Rewrite "What I do for a living" (training first, with the Cursos de git and `/resume/training.html` links; earlier roles and own company; Platform161/Verve 2020–2022 then RubiconMD/CVS Health 2022–2026 with the three titles; "I'm currently open to new opportunities in engineering and training."); check every link in the built `about-me.html`
- [ ] 4.3 Rewrite the pets paragraph (dog 2010; cats Oct 2018 at 120 g, Aug 2020, Jun 2021) and fix the typos; check there's no "5 months old", "weighted" or "join our"

## 5. Verification

- [ ] 5.1 Run `bundle exec jekyll build` with no errors or warnings from the new files, run `jekyll serve`, and go through `/resume/training.html` and `/about-me.html` on desktop and mobile widths
- [ ] 5.2 Robustness check: temporarily copy `trainer.yml` to a scratch location, null out a few optional fields (a course's `materials`, a role's dates, an education `year`), build, check the page still renders cleanly, then restore the original file (it must end up byte-identical: `git diff --exit-code _data/resumes/trainer.yml`)
