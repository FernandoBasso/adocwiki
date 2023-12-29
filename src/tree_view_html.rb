# frozen_string_literal: true

# rubocop: disable Metrics/AbcSize

##
# Generates an HTML navigation of the files in the wiki.
#
class TreeViewHtml
  ##
  # @param {Hash} items The hash describing the naviagation structure
  #   that shall be turned into an HTML structure.
  #
  def initialize(items)
    @items = items
    @nav_html = nil
  end

  def nav_html
    return @nav_html unless @nav_html.nil?

    @nav_html = %(<ul class="navtree">#{to_html(@items)}</ul>)
  end

  private

  ##
  # Generates the HTML ul/li nested list structure for the wiki pages.
  #
  # @param {Hash|Array} val
  # @return {String} The navigation ul/li tree structure.
  #
  def to_html(val)
    return %(<li><a href="/#{val[:path]}.html">#{val[:title]}</a></li>) \
      if val.is_a?(Hash) && val[:path]

    acc = ''

    val.each_pair do |k, v|
      if v.is_a?(Hash)
        acc += %(<li class="topcategory"><button>#{k}</button><ul>)
        acc += to_html(v)
        acc += '</ul></li>'
      elsif v.is_a?(Array)
        acc += %(<li class="category"><a href="/#{v.first[:path]}">#{k}</a><ul class="items">)

        v.each do |v|
          acc += to_html(v)
        end

        acc += '</ul></li>'
      else
        acc += "<li>??? #{k}, #{v}</li>"
      end
    end

    acc
  end
end
