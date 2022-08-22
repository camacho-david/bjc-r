#! /usr/bin/env ruby

IMAGE_SOURCE = '/Volumes/Michael/Users/michael/Desktop/bjc-images/All images'
CUR_SOURCE = 'cur/programming/**/*.html'
BJC_R = './'

def base_name(name)
  name.gsub(IMAGE_SOURCE, '')
end

def transform_filename(name)
  name.gsub('.png', '.es.png')
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

def move_image_files
  images = Dir.glob("#{IMAGE_SOURCE}/*.png")
  html_files = Dir.glob(CUR_SOURCE)
  html_files.each do |file_path|
    next if file_path.match(/\/old/)
    contents = File.read(file_path)
    puts "Processing: #{file_path}"
    images.each do |image_path|
      image_name = base_name(image_path)
      es_name = transform_filename(image_name)
      regexp = /\=\bjc-r\/(.*\/#{es_name})?"/
      image_links = contents.scan(contents)
      puts image_links
      # puts "Replacing #{image_name} with #{transform_filename(image_name)}"
      # new_contents = new_contents.gsub(image_name, )
    end
    # To merely print the contents of the file, use:
    # puts new_contents
  end
end
# puts images

move_image_files
