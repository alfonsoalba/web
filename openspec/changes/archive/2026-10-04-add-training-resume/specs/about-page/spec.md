# Spec Delta

## Purpose

The About page tells visitors who I am, what I do for a living and a little about my personal life, and points them to my resume for details.

## ADDED Requirements

### Requirement: Who I am
The "Who I am" section SHALL be a short, plain introduction: I live in Madrid, I have a PhD in Physics, I have spent over twenty years building software and teaching others to build it, and what I care about at work. The section MUST NOT contain the previous Matrix / red-pill text.

#### Scenario: Plain introduction
- **WHEN** a visitor reads "Who I am"
- **THEN** they see the short introduction and no reference to The Matrix, Morpheus or the red pill

### Requirement: What I do for a living
The "What I do for a living" section SHALL, in this order:
1. Present training as a main activity: more than twenty years training, 110+ courses, 70+ of them about git, a link to Cursos de git (https://www.cursodegit.com), and a link to the training resume at `/resume/training.html`.
2. Mention my earlier engineering roles (full-stack developer, tech lead and CTO) and the company I founded, which didn't work out.
3. In chronological order, name Platform161 (2020–2022, System Administrator and DevOps Engineer, now part of Verve, linking to https://verve.com) and RubiconMD (2022–2026, linking to https://www.rubiconmd.com, now part of CVS Health, linking to https://www.cvshealth.com), with the roles Senior Backend Engineer, Senior Engineering Manager and Senior Staff Software Engineer.
4. End with: "I'm currently open to new opportunities in engineering and training."

The section MUST NOT say I currently work at Platform161 or describe training as a side activity.

#### Scenario: Visitor follows the resume link
- **WHEN** a visitor clicks the training resume link in "What I do for a living"
- **THEN** they land on `/resume/training.html`

#### Scenario: Current status
- **WHEN** a visitor reads "What I do for a living"
- **THEN** it doesn't claim a current employer and it ends by saying I'm open to new opportunities in engineering and training

### Requirement: Personal details
The "Other things about me" section SHALL say I host rescued animals and live with my girlfriend, a dog rescued in 2010, and three cats: one found abandoned in October 2018 (she weighed 120 g), and two rescued cats who joined in August 2020 and June 2021. It MUST NOT state ages that go out of date.

#### Scenario: Pets are current
- **WHEN** a visitor reads "Other things about me"
- **THEN** it lists the dog and three cats with their dates, and there is no "5 months old" or other age stated in the present tense
