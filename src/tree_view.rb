# rubocop: disable all
# frozen_string_literal: true

require 'yaml'
require 'pathname'
require 'awesome_print'

def _ap(obj)
  ap obj, indent: 2
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
    @nav_items = to_html(items, nil, {})
  end

  def to_html(val, key = nil, tree = {})
    return tree if val.nil?

    if val.is_a?(Hash)
      val.each_pair do |k, v|
        return to_html(v, k, tree)
      end
    elsif val.is_a?(Array)
      tree[key] ||= []

      val.each do |file|
        pathname = Pathname.new(file)
        tree[key] << { path: pathname.to_path.gsub('.adoc', '') }
      end

      return tree
    end
  end
end

# h = YAML.load_file("#{__dir__}/test-data/nav.yml")
# _ap h
# _ap TreeView.new(h).nav_items

