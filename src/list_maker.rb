# rubocop: disable all
# frozen_string_literal: true

require 'yaml'
require 'pathname'
require 'yaml'
require 'asciidoctor'
require 'awesome_print'
require 'yaml'

def _ap(acc)
  ap acc, indent: 2
end

class ListMaker
  def initialize(hash)
    @hash = hash
    @indent = '  '
    @level = 0
    @out = []
  end

  def append(tag, val = nil, b = false)
    str = @indent * @level + "#{tag}"

    unless val.nil?
      str += @tag_space + "\n" + @indent * @level + '  ' + val
    end

    str += "\n"

    @out << str
  end

  def ul(hash)
    open_tag('ul') { li(hash) }
  end

  def li(hash)
    @level += 1

    hash.each do |key, val|
      open_tag('li', key) do
        ul(val) if val.is_a?(Hash)
        ul(val) if val.is_a?(Array)
      end
    end

    @level -= 1
  end

  def list
    ul(@hash)
    @out.join
  end
end

class HtmlListMaker < ListMaker
  def initialize(hash)
    super
    @tag_space = ''
  end

  def open_tag(tag, val = nil, &block)
    cssClass = "sub-#{@level}" if tag == 'ul'

    if tag == 'ul' then @level += 1 end

    append("<#{tag} class='#{cssClass}'>", val)
    yield if block_given?
    append("</#{tag}>", nil, true)

    if tag == 'ul' then @level -= 1 end
  end
end

nav = YAML.load_file("#{__dir__}/../test-data/nav.yml")

puts HtmlListMaker.new(nav).list
