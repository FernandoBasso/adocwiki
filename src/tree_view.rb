# frozen_string_literal: true

require 'yaml'
require 'pathname'
require 'asciidoctor'
require 'awesome_print'
require 'htmlbeautifier'

def _ap(acc)
  ap acc, indent: -2
end

##
# Generates the tree view of files in the wiki.
#
class TreeView
  attr_reader :nav_items, :nav_html

  ##
  # @param {Hash} items A hash describing the tree hierarchy
  # @param {String} docsdir Path to the root dir of the docs
  #
  def initialize(items, docsdir)
    @items = items
    @docsdir = docsdir
    @nav_items = walk(items)
    @nav_html = make_nav_html(@nav_items)
  end

  private

  ##
  # Get config hash for file.
  #
  # @param {string} file
  # @return {hash}
  #
  def config(file)
    adoc = Asciidoctor.load_file("#{@docsdir}/#{file}")

    {
      path: file.sub(/\.adoc/, ''),
      title: adoc.title,
      subtitle: adoc.attributes['page-subtitle']
    }
  end

  ##
  # Transforms the input hash into a new hash with extra and modified
  # properties which is then useful for generating the HTML navigation
  # structure and converting using the `Asciidoctor` API.
  #
  # The output hash uses string keys for main category names and symbols
  # for each file information.
  #
  # @param {Hash|Array|String} val
  # @return {Hash}
  #
  def walk(val)
    return config(val) if val.is_a?(String)

    val.each_with_object({}) do |(k, v), acc|
      acc[k] = case v
               when Hash  then walk(v)
               when Array then [*acc[k], *v.map(&method(:walk))]
               else            { path: v }
               end
    end
  end
end

# nav = YAML.load_file("#{__dir__}/../test-data/nav.yml")
# items = TreeView.new(nav, "#{__dir__}/../test-data").nav_items
# _ap items

# beautiful = HtmlBeautifier.beautify(html)
# puts beautiful
