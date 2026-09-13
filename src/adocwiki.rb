#rubocop: disable all

require 'yaml'
require 'fileutils'
require 'pathname'
require 'erb'
require 'asciidoctor'
require_relative 'tree_view'
require_relative 'tree_view_html'
require_relative 'html_render_context'

require 'awesome_print'

def _ap(acc)
  ap acc, indent: -2
end

##
# The `AdocWiki` class is responsible for running the steps necessary
# to build the wiki.
#
class AdocWiki
  def initialize(dir_root)
    @dir_root = dir_root
    @nav_items_orig = YAML.load_file("#{@dir_root}/nav.yml")
    @nav_items = TreeView.new(@nav_items_orig, dir_root).nav_items
    @side_nav = TreeViewHtml.new(@nav_items).nav_html
  end

  def build
    do_level(@nav_items_orig)
    copy_styles
  end

  private

  ##
  # Returns the templates path.
  #
  def templates_path
    "#{@dir_root}/templates"
  end

  ##
  # Returns the template for a given type of content.
  #
  # Possible content types:
  #
  # - article
  # - post
  #
  # @param type {String} One of `article` or `post`.
  #
  def template_for(type)
    path = "#{__dir__}/templates/#{type}.html.erb"

    return path if File.exist?(path)

    raise "No template type “#{type}”."
  end

  ##
  # Converts an AsciiDoc file to html and embeds it into the template.
  #
  # `adoc_file`
  # : A `String` representing the name of the file to be converted.
  #
  def conv(adoc_file)
    adoc = Asciidoctor.load_file("#{@dir_root}/docs/#{adoc_file}", attributes: {
      'source-highlighter' => 'pygments',
      'sectlinks' => true,
      'sectlevels' => 6,
      'icons' => 'font',
    })

    # adoc.outline =
    #   Asciidoctor::Converter.create('html5')
    #   .convert_outline(adoc, toclevels: 6)

    template = ERB.new(
      File.read(template_for('article'), mode: 'r:utf-8')
    )
    file = Pathname.new(adoc_file)

    FileUtils.mkpath("#{@dir_root}/build/#{file.dirname.to_path}")

    ##
    # We'll always provided `adoc`, `outline`, and `nav_html` to the templates,
    # even if it is an empty AsciiDoc document, or empty outline.
    #
    context = HtmlRenderContext.new(
      config: { 'site-title': 'Dev How To' },
      adoc: adoc,
      side_nav: @side_nav,
    )

    html_page = template.result(context.get_binding)

    File.write(
      "#{@dir_root}/build/#{file.dirname.to_path}/#{file.basename.to_path.gsub(/adoc$/, 'html')}",
      html_page
    )
  end

  def do_level(nav_items = @nav_items_orig)
    if nav_items.is_a?(Hash)
      nav_items.each_pair do |key, _val|
        do_level(nav_items[key])
      end
    elsif nav_items.is_a?(Array)
      nav_items.each do |item|
        if item.is_a?(Array)
          do_level(item)
        elsif item.is_a?(Hash)
          do_level(item)
        else
          conv(item)
        end
      end
    end
  end

  def copy_styles
    FileUtils.cp_r(
      "#{__dir__}/_static",
      "#{@dir_root}/build/",
      noop: false,
      verbose: false
    )
  end
end
