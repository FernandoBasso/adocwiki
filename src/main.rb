# rubocop:disable all

#
# Bootstraps the build process.
#
# Needs the path to the root dir which includes the adocwiki.yml
# configuration file.
#
# Call this with a command line this:
#
#     $ ruby path/to/adocwiki/main.rb path/to/docs
#
# Example:
#
#     $ ruby ~/projcts/adocwiki/src/main $PWD
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
