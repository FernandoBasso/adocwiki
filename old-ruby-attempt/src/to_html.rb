# rubocop: disable all

require 'yaml'

def _ap(acc)
  ap acc, indent: 2
end

def to_haml(hash, indent)
  puts ' ' * indent + '<ul>'
  indent += 1
  hash.each do |key, val|
    puts ' ' * indent + '<li>' + key + '</li>'
    to_haml(val, indent + 1) if val.is_a? Hash
  end
end

nav = YAML.load_file("#{__dir__}/../test-data/nav.yml")

to_haml(nav, 0)
