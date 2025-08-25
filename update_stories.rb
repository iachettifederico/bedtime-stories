#!/usr/bin/env ruby
# frozen_string_literal: true

# Smart update script for Project Gutenberg stories
# Only downloads and processes new collections/stories

require "fileutils"
require "digest"

COLLECTIONS = {
  sherlock_adventures: {
    url:       "http://www.gutenberg.org/files/1661/1661-0.txt",
    title:     "The Adventures of Sherlock Holmes",
    author:    "Arthur Conan Doyle",
    year:      "1892",
    genre:     "mystery",
    extractor: :sherlock,
  },
  sherlock_return:     {
    url:       "http://www.gutenberg.org/files/108/108-0.txt",
    title:     "The Return of Sherlock Holmes",
    author:    "Arthur Conan Doyle",
    year:      "1905",
    genre:     "mystery",
    extractor: :sherlock,
  },
  sherlock_memoirs:    {
    url:       "http://www.gutenberg.org/files/834/834-0.txt",
    title:     "The Memoirs of Sherlock Holmes",
    author:    "Arthur Conan Doyle",
    year:      "1894",
    genre:     "mystery",
    extractor: :sherlock,
  },
  sherlock_last_bow:   {
    url:       "http://www.gutenberg.org/files/2350/2350-0.txt",
    title:     "His Last Bow",
    author:    "Arthur Conan Doyle",
    year:      "1917",
    genre:     "mystery",
    extractor: :sherlock,
  },
  sherlock_casebook:   {
    url:       "http://www.gutenberg.org/files/69700/69700-0.txt",
    title:     "The Case-Book of Sherlock Holmes",
    author:    "Arthur Conan Doyle",
    year:      "1927",
    genre:     "mystery",
    extractor: :sherlock,
  },
  grimm:               {
    url:       "http://www.gutenberg.org/files/2591/2591-0.txt",
    title:     "Grimm's Fairy Tales",
    author:    "Jacob Grimm and Wilhelm Grimm",
    year:      "1812",
    genre:     "fantasy",
    extractor: :grimm,
  },
  andersen:            {
    url:       "http://www.gutenberg.org/files/1597/1597-0.txt",
    title:     "Andersen's Fairy Tales",
    author:    "Hans Christian Andersen",
    year:      "1843",
    genre:     "fantasy",
    extractor: :andersen,
  },
  oscar_wilde:         {
    url:       "http://www.gutenberg.org/files/902/902-0.txt",
    title:     "The Happy Prince, and Other Tales",
    author:    "Oscar Wilde",
    year:      "1888",
    genre:     "peaceful",
    extractor: :wilde,
  },
  english_fairy:       {
    url:       "http://www.gutenberg.org/files/7439/7439-0.txt",
    title:     "English Fairy Tales",
    author:    "Joseph Jacobs",
    year:      "1890",
    genre:     "fantasy",
    extractor: :english,
  },
}

def load_processed_collections
  # Track which collections have been processed by storing metadata
  metadata_file = ".story_metadata.json"
  if File.exist?(metadata_file)
    require "json"
    JSON.parse(File.read(metadata_file), symbolize_names: true)
  else
    {}
  end
rescue StandardError
  {}
end

def save_processed_collections(metadata)
  require "json"
  File.write(".story_metadata.json", JSON.pretty_generate(metadata))
end

def collection_already_processed?(collection_name, metadata)
  metadata.key?(collection_name) && metadata[collection_name][:processed]
end

def download_file_if_needed(url, filename)
  if File.exist?(filename)
    puts "  File already exists: #{filename}"
    return true
  end

  puts "  Downloading #{filename}..."
  command = "wget -w 2 -O '#{filename}' '#{url}' >/dev/null 2>&1"
  success = system(command)

  if success && File.exist?(filename)
    puts "  Downloaded #{filename}"
    true
  else
    puts "  Error downloading #{filename}"
    false
  end
end

def clean_gutenberg_text(text)
  start_pattern = /\*{3}\s*START OF (?:THE|THIS) PROJECT GUTENBERG EBOOK.*?\*{3}/mi
  start_match = text.match(start_pattern)
  text = text[start_match.end(0)..-1] if start_match

  end_pattern = /\*{3}\s*END OF (?:THE|THIS) PROJECT GUTENBERG EBOOK.*?\*{3}/mi
  end_match = text.match(end_pattern)
  text = text[0...end_match.begin(0)] if end_match

  text.strip
end

def extract_sherlock_stories(text, collection_info)
  stories = []

  # Find story breaks using Roman numerals
  story_breaks = []
  text.scan(/^([IVX]+)\.\s+(.+)$/) do |roman, title|
    match_pos = text.index("#{roman}. #{title}")
    story_breaks << [match_pos, roman, title.strip] if match_pos
  end

  story_breaks.sort_by! do |pos, _, _|
    pos
  end

  story_breaks.each_with_index do |break_info, index|
    pos, _, title = break_info

    end_pos = if index < story_breaks.length - 1
                story_breaks[index + 1][0]
              else
                text.length
              end

    story_content = text[pos...end_pos].strip
    content_lines = story_content.split("\n")
    content_lines.shift if content_lines.first&.match(/^[IVX]+\.\s+/)
    content = content_lines.join("\n").strip

    next if content.length < 1500

    clean_title = title.gsub(/^A\s+/i, "The ")
    clean_title = clean_title.split.map(&:capitalize).join(" ")

    stories << {
      title:   clean_title,
      content: content,
      genre:   collection_info[:genre],
    }
  end

  stories
end

def extract_grimm_stories(text, collection_info)
  stories = []

  # Look for numbered stories
  story_matches = text.scan(/(\d+)\.\s+([A-Z][A-Z\s,\-:'"!?]+)(?:\n\n|\n(?=[A-Z]))(.*?)(?=\n\n\d+\.\s+[A-Z]|\z)/m)

  story_matches.each do |_number, title, content|
    clean_title = title.strip.split.map(&:capitalize).join(" ")
    clean_content = content.strip

    next if clean_content.length < 800
    next if clean_title.match(/^(contents|table|index)/i)

    stories << {
      title:   clean_title,
      content: clean_content,
      genre:   collection_info[:genre],
    }

    break if stories.length >= 15
  end

  stories
end

def extract_andersen_stories(text, collection_info)
  stories = []

  known_titles = [
    "The Tinder Box", "Little Claus and Big Claus", "The Princess and the Pea",
    "Little Ida's Flowers", "Thumbelina", "The Naughty Boy", "The Traveling Companion",
    "Little Mermaid", "The Emperor's New Clothes", "The Galoshes of Fortune",
    "The Daisy", "The Steadfast Tin Soldier", "The Wild Swans", "The Garden of Paradise",
    "The Flying Trunk", "The Storks"
  ]

  known_titles.each do |story_title|
    title_pattern = Regexp.new(Regexp.escape(story_title), Regexp::IGNORECASE)

    next unless match = text.match(title_pattern)

    story_start = match.begin(0)

    story_end = text.length
    known_titles.each do |other_title|
      next if other_title == story_title

      other_pattern = Regexp.new(Regexp.escape(other_title), Regexp::IGNORECASE)
      next unless other_match = text.match(other_pattern)

      other_start = other_match.begin(0)
      story_end = other_start if other_start > story_start && other_start < story_end
    end

    story_content = text[story_start...story_end].strip
    story_content = story_content.sub(/^#{Regexp.escape(story_title)}/i, "").strip

    next if story_content.length < 1000

    stories << {
      title:   story_title,
      content: story_content,
      genre:   collection_info[:genre],
    }
  end

  stories
end

def extract_wilde_stories(text, collection_info)
  stories = []

  wilde_stories = [
    "The Happy Prince", "The Nightingale and the Rose", "The Selfish Giant",
    "The Devoted Friend", "The Remarkable Rocket"
  ]

  wilde_stories.each do |story_title|
    title_pattern = Regexp.new(Regexp.escape(story_title), Regexp::IGNORECASE)

    next unless match = text.match(title_pattern)

    story_start = match.begin(0)

    story_end = text.length
    wilde_stories.each do |other_title|
      next if other_title == story_title

      other_pattern = Regexp.new(Regexp.escape(other_title), Regexp::IGNORECASE)
      next unless other_match = text.match(other_pattern)

      other_start = other_match.begin(0)
      story_end = other_start if other_start > story_start && other_start < story_end
    end

    story_content = text[story_start...story_end].strip
    story_content = story_content.sub(/^#{Regexp.escape(story_title)}/i, "").strip

    next if story_content.length < 1000

    stories << {
      title:   story_title,
      content: story_content,
      genre:   collection_info[:genre],
    }
  end

  stories
end

def extract_english_stories(text, collection_info)
  stories = []

  # English fairy tales often have clear separations
  parts = text.split(/\n\n\n+/)

  parts.each_with_index do |part, _i|
    next if part.length < 600

    lines = part.strip.split("\n").reject(&:empty?)
    next if lines.empty?

    potential_title = lines.first.strip
    next if potential_title.length > 50 || potential_title.length < 5
    next if potential_title.match(/^(produced by|gutenberg|project)/i)

    content = lines[1..-1].join("\n\n").strip
    next if content.length < 400

    clean_title = potential_title.split.map(&:capitalize).join(" ")

    genre = if clean_title.downcase.include?("jack") || clean_title.downcase.include?("giant")
              "adventure"
            else
              collection_info[:genre]
            end

    stories << {
      title:   clean_title,
      content: content,
      genre:   genre,
    }

    break if stories.length >= 12
  end

  stories
end

def create_safe_filename(title)
  filename = title.downcase
  filename = filename.gsub(/[^a-z0-9\s]/, "")
  filename = filename.gsub(/\s+/, "_")
  filename = filename[0..50]
  "#{filename}.md"
end

def story_already_exists?(title, genre)
  filename = create_safe_filename(title)
  filepath = File.join("stories", genre, filename)
  File.exist?(filepath)
end

def create_story_file(story, collection_info)
  title = story[:title]
  content = story[:content]
  genre = story[:genre]

  # Skip if story already exists
  if story_already_exists?(title, genre)
    puts "  Skipping existing story: #{title}"
    return nil
  end

  filename = create_safe_filename(title)

  # Create genre directory
  genre_dir = "stories/#{genre}"
  FileUtils.mkdir_p(genre_dir)

  # Create YAML front matter and content
  yaml_content = <<~YAML
    ---
    title: "#{title}"
    author: "#{collection_info[:author]}"
    source: "Public Domain - #{collection_info[:title]} (#{collection_info[:year]})"
    ---

    #{content}
  YAML

  filepath = File.join(genre_dir, filename)
  File.write(filepath, yaml_content, encoding: "utf-8")

  puts "  Created: #{filepath}"
  filepath
end

def process_collection(collection_name, collection_info, metadata)
  puts "=== Processing #{collection_info[:title]} ==="

  # Check if already processed
  if collection_already_processed?(collection_name, metadata)
    puts "  Collection already processed, skipping..."
    return []
  end

  # Create temp directory
  FileUtils.mkdir_p("temp_downloads")
  temp_file = "temp_downloads/#{collection_name}.txt"

  # Download if needed
  unless download_file_if_needed(collection_info[:url], temp_file)
    puts "  Failed to download, skipping collection"
    return []
  end

  # Read and clean text
  text = File.read(temp_file, encoding: "utf-8")
  text = clean_gutenberg_text(text)

  # Extract stories based on collection type
  stories = case collection_info[:extractor]
            when :sherlock
              extract_sherlock_stories(text, collection_info)
            when :grimm
              extract_grimm_stories(text, collection_info)
            when :andersen
              extract_andersen_stories(text, collection_info)
            when :wilde
              extract_wilde_stories(text, collection_info)
            when :english
              extract_english_stories(text, collection_info)
            else
              []
            end

  puts "  Found #{stories.length} stories"

  # Create story files
  created_files = []
  new_stories = 0

  stories.each do |story|
    filepath = create_story_file(story, collection_info)
    if filepath
      created_files << filepath
      new_stories += 1
    end
  end

  puts "  Created #{new_stories} new stories (#{stories.length - new_stories} already existed)"

  # Mark collection as processed
  metadata[collection_name] = {
    processed:    true,
    processed_at: Time.now.iso8601,
    story_count:  stories.length,
    new_stories:  new_stories,
  }

  created_files
end

def main
  puts "Smart Project Gutenberg Story Updater"
  puts "Only processes new collections and creates new stories"
  puts

  # Load existing metadata
  metadata = load_processed_collections
  puts "Loaded metadata for #{metadata.keys.length} previously processed collections"

  all_new_stories = []

  # Process each collection
  COLLECTIONS.each do |collection_name, collection_info|
    new_stories = process_collection(collection_name, collection_info, metadata)
    all_new_stories.concat(new_stories)
    puts
  end

  # Save updated metadata
  save_processed_collections(metadata)

  # Clean up temp files
  FileUtils.rm_rf("temp_downloads")

  # Final summary
  puts "=== UPDATE COMPLETE ==="
  puts "New stories created: #{all_new_stories.length}"

  # Count total stories by genre
  %w[mystery fantasy adventure peaceful].each do |genre|
    count = Dir.glob("stories/#{genre}/*.md").length
    puts "  #{genre}: #{count} stories" if count > 0
  end

  total_count = Dir.glob("stories/*/*.md").length
  puts "\nTotal stories in repository: #{total_count}"

  if all_new_stories.length > 0
    puts "\nNew stories added:"
    all_new_stories.each { |story| puts "  - #{File.basename(story)}" }
  else
    puts "\nNo new stories added (all collections already processed)"
  end

  total_count
end

main if __FILE__ == $0
