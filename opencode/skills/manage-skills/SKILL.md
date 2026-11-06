---
name: manage-skills
description: Use when the user wants to find, install, or manage agent skills from skills.sh. Triggers on requests like "find a skill for", "install a skill", "browse skills", "what skills are available", or any mention of skills.sh.
---

# Skill Manager

Browse and install agent skills from [skills.sh](https://www.skills.sh) for use with opencode.

## Workflow

### 1. Finding skills

When the user asks for a skill, search skills.sh:

- Homepage listing: `https://www.skills.sh/` (shows trending and popular skills)
- Topic pages: `https://www.skills.sh/topic/<topic>`
- Official skills: `https://www.skills.sh/official`
- Search: `https://www.skills.sh/` (use the search bar on the site)
- Direct skill page: `https://www.skills.sh/<owner>/<repo>/<skill-name>`

Fetch the relevant page, extract results with names, descriptions, install counts, and links. Present a curated list to the user.

### 2. Getting skill details

For each candidate skill, fetch its detail page to understand:
- What the skill does
- Which agents it supports (look for OpenCode support)
- Install command
- Dependencies or prerequisites

### 3. Installing a skill

Before installing, **always ask the user for approval** with:
- Skill name and description
- The exact install command
- Any prerequisites

The standard install command for skills.sh skills is:

```bash
npx skills add <owner/repo>
```

Or for a specific skill:

```bash
npx skills add <owner/repo/skill-name>
```

This adds the skill to the current project's `.opencode/skills/` directory.

### 4. Listing installed skills

Check the following locations for installed skills:
- `.opencode/skills/` (project-level)
- `~/.config/opencode/skills/` (global)
- `~/.claude/skills/` (external auto-loaded)
- `~/.agents/skills/` (external auto-loaded)

Each skill directory contains a `SKILL.md` file with frontmatter metadata.

### 5. Removing a skill

To remove a skill:
1. Show the user which skill will be removed
2. Get confirmation
3. Delete the skill directory (e.g., `.opencode/skills/<skill-name>/`)

## Important notes

- After installing a skill, remind the user to **restart opencode** for the new skill to be discovered.
- Skills are directories containing a `SKILL.md` file — never delete individual files within a skill directory.
- If a skill doesn't appear after install, check that the skill directory exists and contains a valid `SKILL.md` with proper frontmatter (`name` and `description` fields).
