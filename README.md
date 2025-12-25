# SmAIle static site

A lightweight static website for the SMaiLE project, built with HTML and CSS. The landing page links to three scenario subpages with consistent visuals and accessible defaults.

## Project structure

```
.
├─ index.html              # Landing page (hero, scenario buttons, EU note)
├─ scenario_1.html         # Storytelling – Age of Discovery
├─ scenario_2.html         # The AI Dilemma
├─ scenario_3.html         # A Bite of the Future
├─ styles.css              # Shared styles (themes, layout, components)
├─ scripts.js              # Progressive enhancements (table wrapper)
├─ logo_smaile.avif        # Project logo
├─ logo_eu.avif            # EU logo
└─ README.md               # This file
```

## Visual design system

- Accents
	- Primary accent (orange): `--accent: #fb8c00`
	- Deeper accent: `--accent-strong: #ef6c00`
	- Subtle tint: `--accent-muted: rgba(251,140,0,0.08)`
- Brand highlight
	- Titles (h1) gradient includes brand cyan: `--brand: #00aeef`
- Links
	- Neutral slate link: `--link-color: #374151`; hover: `--link-hover: #111827`
- Background
	- Warm, very light creams with faint orange-tinted blobs

## Page conventions

- All pages include `styles.css`; subpages include `scripts.js` (for table enhancement).
- Subpages also include a fixed-position “Back to Home” pill link.
- The landing page (`index.html`) uses `body.landing` for center layout and animated hero/buttons.

## Editing content

- Edit the relevant `scenario_*.html` file inside the `.container` element.
- For new scenarios, copy an existing `scenario_*.html`, update the `<body class>` and hero title/subtitle, and link it from `index.html`.

## License

///
