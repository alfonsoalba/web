# training-resume Specification

## Purpose
Publishes my training resume as a page on the site, built from a structured data file that is maintained in another repository, so visitors can see what I teach and what I've done.

## Requirements

### Requirement: Training resume page
The site SHALL publish a page at `/resume/training.html` titled "Resume - Training", built from the data file `_data/resumes/trainer.yml`.

#### Scenario: Page is generated
- **WHEN** the site is built with `_data/resumes/trainer.yml` present
- **THEN** the output contains `resume/training.html` with the title "Resume - Training"

### Requirement: Menu entry
The main menu SHALL contain an entry labelled "Resume" that links to the training resume, placed after "About".

#### Scenario: Visitor opens the resume from the menu
- **WHEN** a visitor views any page that shows the main menu
- **THEN** the menu shows "Resume" after "About", and it links to `/resume/training.html`

### Requirement: Data file is used unchanged
The page SHALL render the data file exactly as it arrives from the source-of-truth repository. Building the site MUST NOT require editing, renaming or adding fields to the data file.

#### Scenario: New copy of the data file
- **WHEN** a new version of `trainer.yml` that follows the same structure replaces the old one and the site is rebuilt
- **THEN** the page shows the new content and the build succeeds with no other file changes

### Requirement: Content sections
The page SHALL show these sections from the data file, in this order: basics (name, headline, location, availability, links), key numbers, profile, courses, teaching approach, training experience, engineering experience, talks and community, education, and languages.

#### Scenario: All sections render
- **WHEN** the data file contains every section listed above
- **THEN** each section appears on the page, in that order

### Requirement: Courses with status badges
Courses SHALL be grouped by area. Each course SHALL show its name, its description if there is one, its duration in hours, a link to its materials if there are any, and a status badge with the course's status note. All badges MUST look the same whatever the status is, and every course MUST be shown whatever its status is. The course introduction, delivery details, topics available on request and previously taught technologies SHALL also be shown.

#### Scenario: Course with materials
- **WHEN** a course has a `materials` entry with a URL
- **THEN** the course shows a link with the materials label pointing to that URL

#### Scenario: Course without materials
- **WHEN** a course has `materials: null`
- **THEN** the course shows no materials link and the rest of the course renders normally

#### Scenario: New or in-preparation course
- **WHEN** a course has status `new` and the note "New, in preparation"
- **THEN** the course is listed with a badge reading "New, in preparation", styled the same as every other status badge

### Requirement: Experience sections
Training experience SHALL show each entry's role, organisation (linked if it has a URL), location, date range, and whichever of highlights, sectors, clients and periods (with details) are present. Engineering experience SHALL show each organisation's location, overall date range, every role with its own date range when given, and its highlights or summary, as fully as the data file has them.

#### Scenario: Entry without an organisation
- **WHEN** a training experience entry has `organisation: null`
- **THEN** the entry shows its role and dates with no organisation and no empty link

#### Scenario: Company with several roles
- **WHEN** an engineering entry has more than one item in `roles`
- **THEN** every role is shown with its title and date range

### Requirement: Date formatting
Dates written as `"YYYY"` or `"YYYY-MM"` SHALL appear in a readable form (for example "Dec 2012" or "2019"), and an end date of `null` SHALL appear as "Present".

#### Scenario: Ongoing entry
- **WHEN** an entry has `start: "2012-12"` and `end: null`
- **THEN** its date range shows as "Dec 2012 – Present"

### Requirement: Translatable text
Text stored as a map keyed by language SHALL be shown in the page's language, which is English. If the page's language is missing from a map, the English text SHALL be shown instead. Inline Markdown in text fields SHALL be rendered as formatting, not shown as raw Markdown.

#### Scenario: Inline Markdown link
- **WHEN** a text field contains `[YouTube channel](https://www.youtube.com/@GrupodeusuariosdegitMadrid)`
- **THEN** the page shows a link with the text "YouTube channel" and no literal Markdown

### Requirement: Email address is not shown
The page MUST NOT show the email address from the data file anywhere in its HTML.

#### Scenario: Email address absent
- **WHEN** the built `resume/training.html` is searched for the value of `basics.email`
- **THEN** no match is found

### Requirement: Missing optional data
Fields that are `null`, empty or missing SHALL be left out without empty headings, empty links or a broken build.

#### Scenario: Education without a year
- **WHEN** an education entry has `year: null` and `status: in_progress`
- **THEN** the entry shows as in progress with no empty year
