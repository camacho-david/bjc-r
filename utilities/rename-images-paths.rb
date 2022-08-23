#! /usr/bin/env ruby
# Moving images requires nokogiri to parse html.
# Use `gem install nokogiri` if you need to install it.
require 'nokogiri'

IMAGE_SOURCE = '/Volumes/Michael/Users/michael/Desktop/bjc-images/All images'
CUR_SOURCE = 'cur/programming/**/*.html'
DOC_ROOT = '/bjc-r'
BJC_R = './'

def base_name(name)
  name.gsub(IMAGE_SOURCE, '')
end

def transform_filename(name)
  name.gsub('.png', '.es.png')
end

# src is a full path, return just the filename
def get_en_basefilename(src)
  File.basename(src).gsub('.es', '')
end

images = Dir.glob("#{IMAGE_SOURCE}/*.png")
html_files = Dir.glob(CUR_SOURCE)
def rename_html_paths
  html_files.each do |file_path|
    next if file_path.match(/\/old/)
    text = new_contents = File.read(file_path)

    puts "Processing: #{file_path}"
    images.each do |image_path|
      image_name = base_name(image_path)
      # puts "Replacing #{image_name} with #{transform_filename(image_name)}"
      new_contents = new_contents.gsub(image_name, transform_filename(image_name))
    end
    # To merely print the contents of the file, use:
    # puts new_contents

    if text != new_contents
      puts "Writing changes to: #{file_path}"
      File.open(file_path, "w") { |file| file.puts new_contents }
    end
  end
end

# This assumes the images directory contains all files
# named *.png, without an 'es' translation.
def move_image_files
  images = Dir.glob("#{IMAGE_SOURCE}/*.png")
  html_files = Dir.glob(CUR_SOURCE)
  html_files.each do |file_path|
    next if file_path.match(/\/old/)
    contents = File.read(file_path)
    puts "Processing: #{file_path}"
    page = Nokogiri::HTML(contents)
    page.css('img').each do |img_node|
      src = (img_node.attributes['src'] || img_node.attributes['data-gifffer'])&.value
      if not src
        puts "IMAGE MISSING FILE? #{img_node.to_s}"
        next
      end
      # Don't do anything to about images not in spanish
      next unless src.match(/\.es\.png/)
      # src's are of the form /bjc-r/img/.../pic.png
      repo_file = src.gsub('/bjc-r', '.')
      local_name = get_en_basefilename(src)
      # puts "Will run cp #{IMAGE_SOURCE}/#{local_name} #{repo_file}"
      `cp '#{IMAGE_SOURCE}/#{local_name}' '#{repo_file}'`
    end
  end
end

working_dir = ENV['PWD']
unless File.basename(working_dir) == 'bjc-r'
  raise "You must run this script from the root directory of the repo"
end

move_image_files
