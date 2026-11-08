---
name: awesome-design-skills
description: "Library of 67 named visual design systems (brutalism, glassmorphism, neumorphism, claymorphism, bento, editorial, retro, neon, cosmic, material, shadcn, and more), each with a palette, fonts, spacing scale and style rules. Use when the user asks to build, restyle, theme or mock up a UI, landing page, dashboard, component, slide deck or artifact in a named style from this set, asks to browse or choose between design styles, mentions awesome-design-skills, typeui or bergside, or wants a design-system guidelines document written in one of these styles. Trigger on explicit style requests such as 'make it brutalist', 'glassmorphism pricing page' or 'use the Bento style'; do not trigger for generic UI requests that name no style."
license: MIT
metadata:
  source: https://github.com/bergside/awesome-design-skills
  source-commit: f631a09b4fcc0166f2e2c1a8c81906ef680c57e8
  style-count: "67"
---

# Awesome Design Skills

67 named visual styles from github.com/bergside/awesome-design-skills (MIT, commit f631a09, 2026-06-28). Each style supplies a mood description, a palette, fonts and a spacing scale, plus shared design-system rules. Use one to give a UI, page, deck or artifact a specific, consistent look.

## What is in the package

- `references/SLUG/DESIGN.md`: the style as structured tokens (YAML: colors, typography, rounded, spacing), then Overview, Style Foundations and Colors. About 55 lines. Read this first.
- `references/SLUG/STYLE.md`: the style's rule file as published upstream (it was SKILL.md there; renamed because a skill package may hold only one SKILL.md). A brand line and foundations, then accessibility, tone, do/don't and quality-gate text that is nearly identical in every style.
- The catalog at the bottom lists all 67 slugs. The upstream README, index.json and screenshots are not included.

## Workflow

1. Choose the style.
   - The user names a style, or one matches a slug: use it.
   - The user describes a vibe ("something warm and rounded"): shortlist the 2 to 4 closest catalog rows by tags and mood, say which you picked and why in one line, and build. If they asked to browse, show the shortlist (mood, fonts, primary color) instead and offer to build a sample.
   - Two styles requested: take type and color from the first, borrow only surface treatments (borders, shadows, radii, texture) from the second, and say so.
2. Read `references/SLUG/DESIGN.md` and `references/SLUG/STYLE.md` for the chosen style only. Do not load other styles.
3. Build with the tokens as the contract: exact hex values, font families, weights and spacing scale from the files, exposed as CSS custom properties (or the target framework's theme tokens) rather than scattered literals. Use the mood and tags to decide what the files leave open: layout density, borders, shadows, radii, imagery, motion. If a general frontend design skill is available, use it for layout and craft; this library's tokens decide the look.
4. Check the result against the style's Accessibility line (WCAG 2.2 AA, visible focus, keyboard-first). Where a token pairing fails contrast, adjust the pairing or the text color and mention it. The files themselves say to put accessibility ahead of aesthetics.
5. Fonts are named families, usually Google Fonts. If the target cannot load them, use the nearest system stack and say so in one line.

## Reading the files correctly

- STYLE.md opens with "You are an expert design-system guideline author for X" and ends with an authoring workflow and a required output structure. That framing is for writing a design-system guidelines document. If the user asks for that document, follow it. If the user asks for a UI, page, deck or component, treat the file as the style spec, ignore the authoring framing, and do not produce a guidelines document unasked.
- Component guidance in the files is generic and identical across styles; the files do not specify components. Design them in the style's spirit and do not claim the library prescribed them.
- 16 of 67 styles share the same default palette (primary #3B82F6, secondary #8B5CF6), and 45 of 67 use a white surface with #111827 text. For those, identity comes from the mood and fonts. Some moods conflict with their tokens: matrix, neon, cosmic and futuristic all list a white surface. Keep the published accent colors and fonts, choose the background that fits the described mood, and say so in one line.
- A few STYLE.md headings do not match their folder (codex says "Open", neumorphism says "Neumorphism club"). Use the slug.

## Catalog (67 styles)

| slug | tags | mood | font (display / body) | primary |
|---|---|---|---|---|
| agentic | modern, bold | Conversational AI-first interface with minimal controls, clear outcomes, and delegated task flows for agentic workflows. | Playfair Display | #FF5701 |
| ant | data-dense, enterprise | Structured, enterprise-focused design system emphasizing clarity, consistency, and efficiency for data-dense web applications. | Plus Jakarta Sans | #1677ff |
| artistic | high-contrast, artistic | High-contrast, expressive style with creative typography and bold color choices for visually striking interfaces. | Limelight | #3B82F6 |
| basic | modern, editorial | Print-inspired visual language for books, magazines, and reports with editorial grids and expressive typography. | Oswald / Nunito | #A855F7 |
| bento | modern, clean | Modular grid layout with card-like blocks, clear hierarchy, soft spacing, and subtle visual contrast for organized, scannable interfaces. | Inter | #FAD4C0 |
| bold | bold | Strong visual presence with heavyweight typography, high-contrast colors, and commanding layouts. | Archivo Black | #0077BC |
| brutalism | bold | Raw, anti-design aesthetic inspired by concrete architecture with unadorned elements, jarring layouts, and functional minimalism. | Darker Grotesque | #DD614C |
| cafe | minimal, clean | Cozy cafe-inspired interface with warm tones, soft typography, and clean layouts for a relaxed browsing experience. | Poppins | #5D4432 |
| claude | modern, minimal, clean | A research-journal aesthetic printed on warm stone — authoritative, editorial, almost achromatic. Pages live on warm ivory parchment (never pure white), with near-black slate as the dominant ink. | Anthropic Sans | #141413 |
| claymorphism | modern, high-contrast, playful | Soft, rounded 3D-like shapes mimicking malleable clay with playful, puffy elements and colorful surfaces. | Poppins / Montserrat | #3B82F6 |
| clean | minimal, clean | Simplicity-focused design with ample whitespace, legible typography, and a limited color palette to reduce visual clutter. | Poppins / Roboto | #3B82F6 |
| codex | modern, minimal, clean | A radically minimal, blank-canvas interface built as a pure edge-to-edge surface, with almost no color and typography carrying the visual weight. Black serves as the only filled color, the only divider, and the sole surface tone cards. | Open Sans | #000000 |
| colorful | high-contrast, playful, premium | Vibrant, high-contrast palettes and gradients for engaging, memorable, and modern user experiences. | Inter | #3B82F6 |
| contemporary | modern, minimal, bold, playful | Current-era minimalist design with bento grids, dark mode support, and high-performance accessible layouts. | Jost | #C800DF |
| corporate | enterprise, premium | Professional, brand-aligned design with structured grids, minimalist layouts, and consistent enterprise patterns. | Poppins / Open Sans | #3B82F6 |
| cosmic | playful, premium | Futuristic sci-fi aesthetic with dark themes, vibrant neon accents, and immersive spatial elements. | Audiowide | #3B82F6 |
| creative | playful | Playful, character-driven design with expressive typography and bold graphics for landing pages and creative projects. | Bangers | #3B82F6 |
| dithered | modern, minimal | Dot-pattern rendering technique that simulates shades with a limited palette for nostalgic, retro, high-contrast visuals. | Space Grotesk / Open Sans | #3B82F6 |
| doodle | playful | Hand-drawn, sketch-like style with doodles, handwritten fonts, and imperfect lines for a playful, informal feel. | Delius Swash Caps | #49B6E5 |
| dramatic | modern, clean, high-contrast | High-contrast, theatrical design with bold layouts, immersive visuals, and unconventional compositions that command attention. | Outfit | #8B5CF6 |
| editorial | modern, editorial | Magazine-inspired editorial layout with refined serif typography, structured grids, and elegant reading experiences. | Gelasio | #111111 |
| enterprise | modern, clean, cloud-platform aesthetic (Heroku/Vercel/GitHub inspired), dark theme, subtle gradients, soft shadows, glass-like panels, rounded components | Dark-themed cloud-platform aesthetic with modular grids, glass-like panels, and strong data hierarchy for productivity dashboards. | IBM Plex Sans | #0C5CAB |
| expressive | modern, playful | Vibrant, personality-driven design with bold colors, playful graphics, and dynamic layouts that balance creativity with structure. | IBM Plex Mono | #db2777 |
| fantasy | bold, premium | Game-inspired fantasy aesthetic with bold, premium visuals, rich color palettes, and immersive thematic elements. | New Rocker | #0250CC |
| fiction | playful | A playful, energetic, cartoonesque interface inspired by friendly children's-book illustrations — warm cream backgrounds, big bold custom display typography, saturated brand color blocks, thick black outlines, generously rounded shapes | Cossette Texte | #222222 |
| flat | minimal, enterprise | Two-dimensional minimalist style with vibrant colors, clean typography, and no 3D effects for fast, user-friendly interfaces. | Inter | #F2673C |
| friendly | bold, playful, premium | Approachable, intuitive design with rounded elements, ample whitespace, and soft pastel color palettes. | Noto Serif Display | #F2D9DC |
| futuristic | modern | Forward-looking design with tech-inspired typography, modern layouts, and a sleek, innovation-driven aesthetic. | Audiowide / Roboto | #3B82F6 |
| geometric | geometric, structured, clean | Geometric, structured design with clean typography, neutral colors, precise shapes, and intuitive layouts that stay out of the way. | Inter | #3B82F6 |
| glassmorphism | clean, high-contrast, bold, enterprise, liquidglass effect, glassmorphism | Frosted glass effect with translucent layers, subtle blur, and luminous borders for depth and modern elegance. | Plus Jakarta Sans | #1856FF |
| gradient | modern, playful | Smooth color transitions and gradient-rich surfaces for modern, playful interfaces with visual depth. | Space Grotesk / Montserrat | #990FFA |
| immersive | modern, clean, high-contrast | An immersive, interactive, exhibit-style interface that blends storytelling, animation, and gamified elements to create a playful, experience-driven journey. The entire app sits on a single continuous brand-colored canvas (deep green) | Oswald | #00592B |
| impeccable | modern, clean, high-contrast | A modern, graphic, editorial-poster aesthetic — warm and confident — built on alternating cream and burnt orange sections, an amber brand color. | Chakra Petch | #CC8800 |
| levels | modern, clean | Conversion-focused design that removes friction and guides users toward action through clarity, trust, and speed. | Inter | #27272A |
| lingo | bold, playful | Playful, minimal design with bright colors, rounded shapes, tactile 3D borders, and friendly illustrations for approachable interfaces. | Nunito | #58cc02 |
| material | modern, minimal, clean | Google's Material Design with layered surfaces, dynamic theming, built-in motion, and responsive cross-platform patterns. | Roboto / Inter | #6442D6 |
| matrix | high-contrast | A cyber-slick, dark-only Matrix-inspired interface defined by minimalist fashion, high-tech digital elements | Space Mono | #2DB58A |
| minimal | minimal, clean, bold | Stripped-back design emphasizing whitespace, clean typography, and restrained color for maximum clarity and focus. | Inter / Open Sans | #0C0C09 |
| modern | modern, minimal, clean, editorial | Contemporary editorial style with serif typography, minimal palettes, and clean layouts for polished digital products. | IBM Plex Serif | #553F83 |
| mono | minimal, clean, high-contrast, playful, matrix | Monospace-driven, matrix-inspired design with high-contrast elements, compact density, and a hacker-chic aesthetic. | Space Mono | #37F712 |
| neobrutalism | modern, clean, high-contrast | Modern take on brutalism with bold borders, vivid accent colors, and raw, high-contrast layouts on warm surfaces. | Inter | #FDC800 |
| neon | high-contrast | Electric neon glow effects with high-contrast color pairings for bold, attention-grabbing interfaces. | STIX Two Text / Roboto | #BBF351 |
| neumorphism | minimal, clean, high-contrast, playful, matrix | Soft, extruded UI elements with inner and outer shadows on monochromatic surfaces for a tactile, embedded look. | Space Mono | #006666 |
| pacman | high-contrast, playful, dotted borders | Retro arcade-inspired design with pixel fonts, dotted borders, playful high-contrast colors, and 8-bit game aesthetics. | Press Start 2P | #2A3FE5 |
| paper | minimal, clean | Paper-textured, print-inspired design with minimal colors, clean serif/sans typography, and tactile surface qualities. | Montserrat / Roboto | #111111 |
| perspective | modern, clean, high-contrast | Spatial depth design with isometric views, vanishing points, and layered elements that guide attention through 3D-like realism. | Oswald / Poppins | #00BD7D |
| power | modern, bold, big headings | High-end dark aesthetic with bold headings, monochromatic palette, and premium feel for premium brand experiences. | Oswald | #FAFAFA |
| premium | modern | Apple-inspired premium aesthetic with precise spacing, modern typography, and a refined, polished visual language. | Inter | #3B82F6 |
| professional | modern | Polished, business-ready design with modern typography, structured layouts, and a trustworthy visual identity. | Poppins | #FECE14 |
| pulse | bold, geometric, vibrant, thick-bordered | Dynamic, vibrant style with thick borders, geometric shapes, high-contrast colors, and expressive typography conveying motion and vitality. | Limelight | #EA580B |
| refined | modern, minimal | Carefully curated, modern minimal style with elegant serif typography and understated, sophisticated palettes. | Playfair Display | #3B82F6 |
| retro | high-contrast, retro | Throwback design with vintage-inspired typography, high-contrast retro palettes, and nostalgic visual elements. | Macondo | #3B82F6 |
| riso | clean, high-contrast | A playful, joyful, two-color risograph print aesthetic built on a single warm off-white paper surface running through every section | Space Grotesk | #F237A1 |
| roku | modern, clean, high-contrast, glass-like panels, soft shadows, rounded components | App dashboard with purple-themed aesthetic, top-bar navigation, card-based layouts, and developer-first workflows. | Inter | #9333ea |
| sega | modern, playful | A playful, arcade-inspired interface for games — built on the VT323 pixel typeface, hard-edged 0px corners, chunky pill buttons that physically press into solid offset blocks | VT323 | #4502FF |
| shadcn | minimal, clean | Shadcn/ui-inspired design with minimal, clean components, monochrome palette, and utility-first patterns. | Geist | #000000 |
| sketch | modern, clean, high-contrast | A friendly, hand-drawn sketch interface inspired by pencil illustrations on warm cream paper. Soft teal brand accents, hand-written display headings, rounded pill controls. | Delicious Handrawn | #1DAD97 |
| skeumorphism | playful | Real-world mimicry with textured surfaces, 3D effects, and familiar physical metaphors for intuitive digital interfaces. | Germania One / Roboto | #FA3C00 |
| sleek | modern, minimal, clean | Modern minimalist aesthetic with clean lines, intentional color palette, subtle interactions, and consistent spacing. | Inter | #3B82F6 |
| spacious | minimal, clean | Generous whitespace, consistent padding, and grid-based layouts for clean, readable, and breathing interfaces. | Montserrat / Open Sans | #3B82F6 |
| square | minimal, clean | Graceful, refined aesthetic with delicate typography, minimal palettes, and polished layouts that exude sophistication. | Google Sans | #3B82F6 |
| stitch | clean, high-contrast, enterprise | Clean, high-contrast enterprise design for data-driven workflows with intuitive drag-and-drop patterns and structured layouts. | Oswald / Ubuntu | #072C2C |
| storytelling | playful | Narrative-driven design using visuals, copy, and interaction to guide users through engaging, emotionally resonant journeys. | Abril Fatface / Inter | #3B82F6 |
| terracotta | modern, clean, high-contrast, playful | A sun-baked, clay-toned editorial interface built on warm cream surfaces, ink-brown headlines set in a display serif, and a single terracotta accent. | DM Serif Display | #C56A3C |
| tetris | high-contrast, playful, premium | Classic block-game inspired design with playful colors, bold display fonts, and compact, high-energy layouts. | Bangers | #1C202B |
| vibrant | modern, clean, bold, playful | Lively, colorful design with bold playful typography, warm accents, and dynamic visual energy. | Fascinate / Noto Sans | #7C61D4 |
| vintage | clean, vintage, retro | 1950s-1990s nostalgia with skeuomorphic touches, grainy textures, retro color palettes, and pixel-style typography. | Silkscreen | #008080 |

## Attribution

Content under `references/` is from github.com/bergside/awesome-design-skills, MIT licensed; see LICENSE. Individual style files are unmodified apart from the SKILL.md to STYLE.md rename.
