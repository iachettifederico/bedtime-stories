# Agent Guidelines for Bedtime Stories Repository

## Repository Purpose
This repository contains curated bedtime stories for the PixelDeck bedtime stories application. Stories are organized by genre and automatically synced to the main application database when changes are pushed.

## Repository Structure
```
bedtime-stories/
├── stories/
│   ├── adventure/
│   │   ├── treasure_hunt.md
│   │   └── mountain_climb.md
│   ├── fantasy/
│   │   ├── happy_prince.md
│   │   └── magic_garden.md
│   ├── mystery/
│   │   └── stolen_letter.md
│   └── peaceful/
│       └── garden_party.md
├── AGENTS.md
└── README.md
```

## How Sync Works
1. **PixelDeck app deployment** triggers automatic sync
2. **GitHub API scanned** for genre directories in `/stories/`
3. **All .md files discovered** and processed
4. **YAML front matter extracted** for metadata
5. **Database updated** with stories and metadata
6. **Content served** from GitHub when users request stories

## Creating a New Story

### Step 1: Choose or Create Genre Directory
- **Existing genres**: Use existing folders like `adventure/`, `fantasy/`, `mystery/`, `peaceful/`
- **New genre**: Create a new folder under `/stories/` (e.g., `/stories/horror/`)
- **Naming**: Use snake_case for genre folders (e.g., `science_fiction/`, `fairy_tales/`)

### Step 2: Create Story File
Create a new `.md` file in the genre directory:

**File naming conventions:**
- Use descriptive, snake_case names: `happy_prince.md`, `treasure_island.md`
- Avoid special characters and spaces
- Use `.md` extension

### Step 3: Add YAML Front Matter
Every story file MUST start with YAML front matter:

```markdown
---
title: "The Story Title"
author: "Author Name"
read_time_minutes: 12
source: "Public Domain (1888)"
---

Story content goes here...
```

**Required fields:**
- `title`: Display title (use quotes for titles with punctuation)
- `author`: Author name
- `source`: Attribution/copyright info

**Optional fields:**
- `read_time_minutes`: Reading time (auto-calculated if omitted)

### Step 4: Write Story Content
- **Target length**: 5-20 minutes reading time (~1000-4000 words)
- **Use markdown formatting**: Headers, emphasis, etc.
- **Keep it appropriate**: Suitable for bedtime reading
- **Public domain preferred**: Avoid copyright issues

## Story Content Guidelines

### Recommended Genres
- **adventure**: Action, exploration, journeys
- **fantasy**: Magic, mythical creatures, enchanted worlds  
- **mystery**: Puzzles, detective stories, gentle mysteries
- **peaceful**: Calm, soothing, contemplative stories
- **fairy_tales**: Classic and modern fairy tales
- **science_fiction**: Gentle sci-fi, space exploration

### Content Standards
- **Family-friendly**: Appropriate for all ages
- **Positive themes**: Hope, friendship, wonder, growth
- **Avoid**: Violence, scary content, complex themes
- **Length**: 300-4000 words (2-20 minute read time)

### Quality Standards
- **Well-written**: Good grammar, engaging narrative
- **Complete stories**: Clear beginning, middle, end
- **Standalone**: Each story should be self-contained
- **Attribution**: Proper credit for authors and sources

## Example Story Template

```markdown
---
title: "The Enchanted Library"
author: "Jane Smith"
read_time_minutes: 15
source: "Public Domain (1923)"
---

# The Enchanted Library

In a quiet corner of the old town, where cobblestone streets wound between ancient buildings, stood a library that seemed to shimmer with its own inner light.

[Continue story content...]

The end.
```

## Testing Your Changes
1. **Push to GitHub** - Changes trigger automatic sync
2. **Check PixelDeck app** - New stories appear after deployment
3. **Verify metadata** - Title, author, read time display correctly
4. **Test content** - Story loads and displays properly

## Common Issues

### YAML Parsing Errors
- **Quotes required**: Use quotes around titles with colons, apostrophes
- **Proper indentation**: Use spaces, not tabs
- **Valid YAML**: Test with online YAML validator

### Missing Stories
- **File extension**: Must be `.md`
- **Valid YAML**: Front matter must parse correctly
- **Repository access**: Must be public or have proper credentials

### Sync Failures
- **Check GitHub API limits**: May need authentication for private repos
- **Verify file paths**: Ensure no special characters in filenames
- **Test YAML syntax**: Invalid front matter prevents sync

Remember: Each story file becomes automatically available in the PixelDeck bedtime stories app. Changes sync immediately on deployment!