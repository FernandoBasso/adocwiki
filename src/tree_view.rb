# frozen_string_literal: true

require 'yaml'
require 'pathname'
require 'awesome_print'

def _ap(acc)
  ap acc, indent: 2
end

##
# Generates the tree view of files in the wiki.
#
class TreeView
  attr_reader :nav_items

  ##
  # @param {Hash} items A hash describing the tree hierarchy
  #
  def initialize(items)
    @items = items
    @nav_items = walk(items)
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
    return { path: val.sub('.adoc', '') } if val.is_a?(String)

    val.each_with_object({}) do |(k, v), acc|
      acc[k] = case v
               when Hash  then walk(v)
               when Array then [*acc[k], *v.map(&method(:walk))]
               else            { path: v }
               end
    end
  end
end
