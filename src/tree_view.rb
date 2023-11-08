# rubocop: disable Metrics/AbcSize
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
      title: adoc.title
    }
  end

  def make_nav_html(nav_hash)
    %(<ul class="navtree">#{to_html(nav_hash)}</ul>)
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

  ##
  # Generates the HTML ul/li nested list structure for the wiki pages.
  #
  # @param {Hash|Array} val
  # @return {String} The navigation ul/li tree structure.
  #
  def to_html(val)
    return %(<li><a href="/#{val[:path]}.html">#{val[:title]}</a></li>) if val.is_a?(Hash) && val[:path]

    acc = ''

    val.each_pair do |k, v|
      if v.is_a?(Hash)
        acc += %(<li class="topcategory"><button>#{k}</button><ul>)
        acc += to_html(v)
        acc += '</ul></li>'
      elsif v.is_a?(Array)
        acc += %(<li class="category"><button>#{k}</button><ul class="items">)
        v.each do |v|
          acc += to_html(v)
        end
        acc += '</ul></li>'
      else
        acc[k] = "<li>??? #{k}, #{v}</li>"
      end
    end

    acc
  end
end

nav = YAML.load_file("#{__dir__}/../test-data/nav.yml")
items = TreeView.new(nav, "#{__dir__}/../test-data").nav_items
_ap items

# beautiful = HtmlBeautifier.beautify(html)
# puts beautiful
#
