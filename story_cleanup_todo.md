# Bedtime Stories Cleanup Progress Tracker

## Purpose
This file tracks the progress of cleaning up all story files in the bedtime-stories repository. The goal is to ensure each story file:

1. **Contains only one complete story** (split files with multiple stories)
2. **Has clean, human-readable content** without boilerplate or formatting garbage
3. **Proper YAML front matter** with title, author, and source
4. **Story content only** - remove any project gutenberg headers, footers, or other non-story text

**Strategy**: Work through simple single-story files first, then tackle major collection files that need splitting.

---

## STATUS SUMMARY
- ✅ **Completed**: 4 files
- 🔄 **Simple files remaining**: 23 files  
- ⚠️ **Major splitting tasks**: 4+ collection files (will add individual stories as discovered)

---

## COMPLETED FILES ✅

### Adventure Stories (2/2 complete)
- ✅ **adventure/the_lost_compass.md** - Fixed copyright issue ("Original Story 2025" → "Public Domain"), removed duplicate title
- ✅ **adventure/the_paper_boat_journey.md** - Fixed copyright issue ("Original Story 2025" → "Public Domain"), removed duplicate title

### Fantasy Stories (2/7 complete)
- ✅ **fantasy/the_midnight_library.md** - Fixed copyright issue ("Original Story 2025" → "Public Domain"), removed duplicate title  
- ✅ **fantasy/how_chanticleer_and_partlet_went_to_visit_mr_korbes.md** - Contains 3 related stories, already clean with proper YAML

---

## PENDING SIMPLE FILES 🔄

### Fantasy Stories (2 simple files remaining)
- [ ] fantasy/the_sleepy_dragon.md  
- [ ] fantasy/the_storks.md

### Mystery Stories (18 simple files - status unknown)
- [ ] mystery/the_adventure_of_cover.md
- [ ] mystery/the_adventure_of_the_beryl_coronet.md
- [ ] mystery/the_adventure_of_the_blue_carbuncle.md
- [ ] mystery/the_adventure_of_the_copper_beeches.md
- [ ] mystery/the_adventure_of_the_engineers_thumb.md
- [ ] mystery/the_adventure_of_the_noble_bachelor.md
- [ ] mystery/the_adventure_of_the_speckled_band.md
- [ ] mystery/the_boscombe_valley_mystery.md
- [ ] mystery/the_case_of_identity.md
- [ ] mystery/the_final_problem.md
- [ ] mystery/the_five_orange_pips.md
- [ ] mystery/the_gloria_scott.md
- [ ] mystery/the_man_with_the_twisted_lip.md
- [ ] mystery/the_redheaded_league.md
- [ ] mystery/the_scandal_in_bohemia.md

### Peaceful Stories (3 simple files remaining)
- [ ] peaceful/the_happy_prince.md
- [ ] peaceful/the_remarkable_rocket.md
- [ ] peaceful/the_tea_garden.md

---

## MAJOR SPLITTING TASKS ⚠️

### Large Collection Files (need to be split into individual stories)
- [ ] **fantasy/grimms_fairy_tales.md** 
  - Status: ~16,000 lines containing 40+ individual Grimm fairy tales
  - Action needed: Split into individual story files, delete original
  - Individual stories will be added to tracking as they are created

- [ ] **fantasy/produced_by_dianne_bean.md** 
  - Status: Multiple Andersen fairy tales (The Emperor's New Clothes, The Swineherd, etc.)
  - Action needed: Split into individual story files, delete original
  - Individual stories will be added to tracking as they are created

- [ ] **fantasy/the_naughty_boy.md**
  - Status: MISNAMED - actually contains multiple Andersen stories (overlaps with produced_by_dianne_bean.md)
  - Action needed: Split into individual story files, delete original, resolve duplicates
  - Individual stories will be added to tracking as they are created

- [ ] **mystery/the_adventures_of_sherlock_holmes.md**
  - Status: Unknown - likely contains multiple Holmes stories
  - Action needed: Investigate and split if necessary

- [ ] **mystery/the_return_of_sherlock_holmes.md**
  - Status: Unknown - likely contains multiple Holmes stories  
  - Action needed: Investigate and split if necessary

- [ ] **mystery/the_casebook_of.md**
  - Status: Unknown - likely contains multiple Holmes stories
  - Action needed: Investigate and split if necessary

---

## NEXT ACTIONS
1. Continue with simple files to build momentum: fantasy/the_naughty_boy.md
2. Investigate mystery files to determine which are simple vs collections
3. Tackle collection splitting tasks once simple files are done

---

**Last Updated**: 2025-08-26  
**Current Session Progress**: 4 files completed