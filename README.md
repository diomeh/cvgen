# Resume Generator

A multilingual resume generator that compiles beautifully formatted PDF resumes from YAML content files using [Typst](https://typst.app/) templates,
with a [Rust](https://www.rust-lang.org/) script to abstract and orchestrate the compilation pipeline.

> [!NOTE]
> The resume template (`templates/cv.typ`) is a modified version of the
> **Bullet Point Resume Template** by [Harvard FAS Career Services](https://careerservices.fas.harvard.edu/resources/bullet-point-resume-template/),
> adapted into a Typst layout for programmatic PDF rendering.

---

## How It Works

```
YAML content file (e.g. content/en.yml)
        │
        ▼
Rust script
(calls Typst with context)
        │
        ▼
Typst template (.typ)
(layout, typography, styling)
        │
        ▼
Compiled PDF resume (dist/)
```

1. You write your resume data in a YAML file (one per language/locale).
2. The Rust script calls the Typst compiler once for each content file found in `content/`, along with any custom fonts in `fonts/`.
3. Typst renders the final PDF using the template.

---

## Project Structure

```
.
├── templates/
│   └── cv.typ              # Typst resume template
├── content/
│   └── example.yml         # Demo content file (see Localization Guide)
├── src/
│   └── main.rs             # Rust entrypoint
├── fonts/                  # Custom fonts (optional)
├── dist/                   # Generated PDFs (git-ignored)
├── .gitattributes          # Enforces LF line endings
├── Cargo.toml
└── README.md
```

---

## Prerequisites

Make sure the following are installed before getting started:

| Tool  | Version | Install                                                               |
|-------|---------|-----------------------------------------------------------------------|
| Rust  | ≥ 1.75  | [rustup.rs](https://rustup.rs)                                        |
| Typst | ≥ 0.11  | [typst.app/docs](https://typst.app/docs/) or `cargo install typst-cli` |

Verify installations:

```bash
rustc --version
typst --version
```

---

## Setup & Installation

### 1. Clone the repository

```bash
git clone https://github.com/your-username/resume-generator.git
cd resume-generator
```

### 2. Add your content file

Create your own YAML file inside `content/` (see [Localization Guide](#localization-guide)):

```bash
cp content/example.yml content/en.yml
```

### 3. Generate resumes

```bash
cargo run
```

This reads all `content/*.yml` files (skipping `example.yml`), renders them through `templates/cv.typ`, and outputs compiled PDFs to `dist/`.

---

## Localization Guide

Each language variant is a standalone YAML file inside the `content/` directory. 
Only human-readable **values** are translated — all **keys** remain in English for code compatibility.

The file `content/example.yml` is a tracked demo file with placeholder data. 
Your personal content files (e.g. `en.yml`, `es.yml`) are git-ignored and should never be committed to a public repository, 
as they contain personally identifiable information (PII) such as phone number and email.

### Adding a new language

**Step 1.** Duplicate the example file:

```bash
cp content/example.yml content/fr.yml
```

**Step 2.** Fill in your data and translate all string values. Do **not** translate keys.

```yaml
# Correct — only values are translated
ui:
  skills: "Compétences Techniques"

# Wrong — keys must stay in English
ui:
  competences: "Compétences Techniques"
```

**Step 3.** Generate the resumes:

```bash
cargo run
```

### YAML file structure

| Field              | Type     | Description                                      |
|--------------------|----------|--------------------------------------------------|
| `ui`               | object   | Translatable UI section labels                   |
| `name`             | string   | Full name                                        |
| `email`            | string   | Contact email                                    |
| `phone`            | string   | Contact phone (include country code)             |
| `linkedin`         | string   | LinkedIn profile URL                             |
| `skills[]`         | array    | Skill categories with `label` and `value` fields |
| `experience[]`     | array    | Work history entries (see below)                 |
| `certifications[]` | array    | Certifications and awards (see below)            |

#### `experience[]` entry

| Field      | Type     | Description                            |
|------------|----------|----------------------------------------|
| `company`  | string   | Employer name                          |
| `role`     | string   | Job title                              |
| `location` | string   | Work modality and country              |
| `period`   | string   | Year or range, e.g. `"2022 - 2024"`   |
| `bullets`  | string[] | Achievement items (action-verb format) |

#### `certifications[]` entry

| Field    | Type   | Description              |
|----------|--------|--------------------------|
| `name`   | string | Institution or cert name |
| `detail` | string | Short description        |
| `url`    | string | Verification URL         |
| `year`   | string | Year obtained            |

### Conventions

- **Periods** — always strings (`"2022 - 2024"`) to prevent YAML from parsing as arithmetic.
- **URLs** — never translated; identical across all locale files.
- **Bullet points** — written in past tense, starting with an action verb (e.g. *Designed*, *Optimized*, *Built*).
- **Proper nouns** (frameworks, companies, tools) — never translated.

---

## License

This project is licensed under the [MIT License](./LICENSE).
