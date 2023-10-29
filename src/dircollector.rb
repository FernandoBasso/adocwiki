# rubocop:disable all

files = []

Dir.glob('*/*.adoc') do |file|
  files << file
end

p files.length
p files
