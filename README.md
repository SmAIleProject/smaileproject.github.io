# SmAIle Static Site

Static website for the SmAIle project. The site is built from plain HTML, CSS, and a small amount of JavaScript. There is no build step for the website itself.

## Repository layout

Top-level pages:

- `index.html`: landing page
- `scenarios.html`: scenario index page
- `materials.html`: materials/resources page
- `moocs.html`: MOOCs page
- `scenario_*.html`: individual scenario pages

Shared site assets:

- `styles.css`: shared site styles
- `scripts.js`: small client-side enhancements
- `attachments/`: downloadable ZIPs, images, and supporting files
- `pdfs/`: public scenario PDFs used by the site
- `assets/`: additional static assets

LaTeX source material:

- `latex/scenario_*/`: editable LaTeX source folders for each scenario

Publishing support:

- `publish.sh`: creates a deployable snapshot from `main` into `public` and pushes it to GitHub Pages

## Working on the site

Edit the HTML files directly. Most content changes will be in:

- `index.html`
- `scenarios.html`
- `materials.html`
- `moocs.html`
- `scenario_*.html`

For styling changes, edit `styles.css`. For small behavior changes, edit `scripts.js`.

## Local preview

Serve the repository root with a lightweight HTTP server:

```bash
python3 -m http.server 8000
```

Then open:

```text
http://localhost:8000
```

Notes:

- Run the server from the repository root so links to `attachments/`, `pdfs/`, and other pages resolve correctly.
- Keep the server running while you edit files and refresh the browser to see changes.
- If port `8000` is busy, use another port, for example:

```bash
python3 -m http.server 8080
```

## Recommended website workflow

1. Switch to the working branch:

```bash
git checkout main
```

2. Edit the relevant HTML, CSS, JS, attachment, or PDF files.
3. Preview locally with `python3 -m http.server 8000`.
4. Check the affected pages in the browser.
5. Commit changes on `main`.
6. Publish only after the local preview looks correct.

## LaTeX sources

The repository stores the source material used to generate the public PDFs in `pdfs/`.

Current structure:

- `latex/scenario_<name>/main_EN.tex`: full scenario document in English
- `latex/scenario_<name>/pamphlet_EN.tex`: pamphlet in English
- `latex/scenario_<name>/main_FR.tex`, `main_ES.tex`, `main_CRO.tex`: translation placeholders or translations
- `latex/scenario_<name>/pamphlet_FR.tex`, `pamphlet_ES.tex`, `pamphlet_CRO.tex`: translation placeholders or translations
- `latex/scenario_<name>/smaile_brand_assets/`: logos and shared branding files required by that scenario project

Important:

- The `latex/` directory is intentionally excluded from the published site.
- These files are versioned in git for collaboration, but they must not be publicly downloadable from GitHub Pages.

## Generating scenario PDFs locally

Recommended local toolchain on Debian:

```bash
sudo apt install texlive-full latexmk
```

Each scenario is self-contained in its own folder under `latex/`, so you can compile directly on your machine without Overleaf.

### Manual compilation

Example:

```bash
cd latex/scenario_bite_future_13-16
latexmk -pdf main_EN.tex
latexmk -pdf pamphlet_EN.tex
```

This produces:

- `main_EN.pdf`
- `pamphlet_EN.pdf`

The public site expects these files to be copied into `pdfs/` with this naming convention:

```text
pdfs/scenario_<name>_document.pdf
pdfs/scenario_<name>_pamphlet.pdf
```

Example:

```text
pdfs/scenario_bite_future_13-16_document.pdf
pdfs/scenario_bite_future_13-16_pamphlet.pdf
```

### Build script

Use the repository helper script from the project root:

```bash
./build_pdfs.sh <scenario_name> [document|pamphlet|both]
```

Examples:

```bash
./build_pdfs.sh scenario_ai_arts_13-16
./build_pdfs.sh scenario_ai_arts_13-16 document
./build_pdfs.sh all both
```

What it does:

- compiles `main_EN.tex` and/or `pamphlet_EN.tex` with `latexmk`
- leaves the generated PDFs in the scenario folder
- copies the public outputs into `pdfs/` using the correct website filenames

### Overleaf fallback

If local compilation is unavailable, each `latex/scenario_*` folder can still be uploaded as a standalone Overleaf project.

## Adding a new scenario LaTeX source

Recommended approach:

1. Copy the closest existing scenario folder in `latex/`.
2. Update `main_EN.tex` and `pamphlet_EN.tex`.
3. Leave unused translation files empty until translations are available.
4. Keep branding files in that scenario folder so the project stays self-contained for local or Overleaf compilation.

## Publishing

The repository uses two local branches for deployment:

- `main`: working branch
- `public`: branch used to create the deployable snapshot

The `publish.sh` script publishes the site by pushing the local `public` branch to the remote `gh-pages` branch.

### What `publish.sh` does

When you run:

```bash
./publish.sh
```

the script performs this sequence:

1. Checks out `main`.
2. Stops if `main` has uncommitted changes.
3. Asks for confirmation before publishing.
4. Checks out `public`.
5. Clears the tracked contents of `public`.
6. Copies the tracked website files from `main`.
7. Removes `latex/` from the public snapshot.
8. Prompts for one more confirmation.
9. Commits on `public`.
10. Pushes `public` to `origin/gh-pages`.
11. Switches back to `main`.

### Why this script exists

The script keeps everyday work on `main` and publishes only a clean snapshot of the website. That means:

- your intermediate commits stay on `main`
- the deploy branch contains only public website history
- non-public source material such as `latex/` stays out of GitHub Pages

### Before running the publish script

Make sure that:

- you are in the repository root
- your local preview looks correct
- your work on `main` is committed
- your public PDFs and attachments are already in place
- you are ready to create a public snapshot

### Running the publish script

If needed, make it executable once:

```bash
chmod +x publish.sh
```

Then run:

```bash
./publish.sh
```

The script will ask:

- whether you want to proceed with publication
- whether the copied files look correct
- for a public commit message

## GitHub Pages target

The site is expected to be available at:

```text
https://smaileproject.github.io
```
