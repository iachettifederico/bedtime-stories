# Bedtime Stories Collection

A curated collection of soothing bedtime stories for the PixelDeck bedtime stories application. This repository automatically syncs with the main application to provide fresh content for peaceful slumber.

## 🌙 Purpose

This repository contains public domain and original bedtime stories organized by genre. Stories are automatically discovered and synced to the PixelDeck application when changes are pushed to the main branch.

## 📁 Repository Structure

```
bedtime-stories/
├── stories/
│   ├── adventure/      # Adventure and exploration stories
│   ├── fantasy/        # Magic and enchanted tales  
│   ├── mystery/        # Gentle mysteries and puzzles
│   ├── peaceful/       # Calm, contemplative stories
│   └── [genre]/        # Add new genres as needed
├── AGENTS.md          # Detailed guidelines for contributors
└── README.md          # This file
```

## 📖 How It Works

1. **Stories are organized by genre** in the `/stories/` directory
2. **Each story is a markdown file** with YAML front matter for metadata
3. **Genres are auto-discovered** from directory names
4. **Stories sync automatically** when the main PixelDeck app deploys
5. **Content is served** from GitHub when users read stories

## 🌟 Story Format

Each story file must include YAML front matter:

```markdown
---
title: "The Story Title"
author: "Author Name"  
read_time_minutes: 12
source: "Public Domain (1888)"
---

Once upon a time, in a land far away...

[Story content continues...]
```

## 🎯 Content Guidelines

- **Family-friendly**: Appropriate for all ages
- **Positive themes**: Hope, wonder, friendship, growth  
- **5-20 minute reads**: Ideal bedtime story length
- **Public domain preferred**: Avoid copyright issues
- **Well-written**: Engaging, complete narratives

## 🚀 Contributing

1. **Choose a genre** or create a new one
2. **Create a .md file** with proper YAML front matter
3. **Write or curate** an appropriate bedtime story
4. **Test locally** by validating YAML syntax
5. **Push changes** - they'll sync automatically!

See **AGENTS.md** for detailed contribution guidelines.

## 📚 Current Collection

- **Adventure**: Tales of exploration and discovery
- **Fantasy**: Magical worlds and enchanted creatures
- **Mystery**: Gentle puzzles and detective stories  
- **Peaceful**: Calm, contemplative bedtime tales

## 🔄 Automatic Sync

This repository integrates with the PixelDeck application:

- **Push to main branch** → Triggers deployment
- **GitHub API scanned** → Discovers all story files  
- **Metadata extracted** → From YAML front matter
- **Database updated** → Stories available immediately
- **Content served** → From GitHub on user request

No manual intervention required - just add stories and they appear!

---

*Part of the PixelDeck collection of useful tools and entertainment.*