# rubocop:disable all

#
# Bootstraps the build process.
#
# Needs the path to the root dir which includes the adocwiki.yml
# configuration file.
#


dir_root = ARGV.first

if dir_root.nil?
  raise 'No path to the root dir of the wiki was provided.'
end


p "DEBUG: #{ENV['DEBUG']}"
p "dir_root: #{dir_root}" if ENV['DEBUG']

require_relative 'adocwiki'

adoc = AdocWiki.new(dir_root)
adoc.build
