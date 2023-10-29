require 'yaml'
require 'fileutils'
require 'pathname'
require 'erb'
require 'asciidoctor'

##
# The `AdocWiki` class is responsible for running the steps necessary
# to build the wiki.
#
class AdocWiki
  def initialize(dir_root)
    @dir_root = dir_root
    @nav_items = YAML.load_file("#{@dir_root}/nav.yml")
    p @nav_items if ENV['debug']
  end

  def build
    do_level
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
  # Converts an Asciidoc file to html and embeds it into the template.
  #
  # @param {string} adoc_file
  #
  def conv(adoc_file)
    adoc = Asciidoctor.load_file(adoc_file)
    rhtml = ERB.new(File.read(template_for('article'), mode: 'r:utf-8'))
    file = Pathname.new(adoc_file)

    FileUtils.mkpath("build/#{file.dirname.to_path}")

    ##
    # `adoc` variable will be available inside the template as `adoc`
    #
    html_page = rhtml.result(binding)

    File.write(
      "build/#{file.dirname.to_path}/#{file.basename.to_path.gsub(/adoc$/, 'html')}",
      html_page
    )
  end

  def do_level(nav_items = @nav_items)
    if nav_items.instance_of?(Hash)
      p 'obj is hash' if ENV['DEBUG']

      nav_items.each_pair do |key, _val|
        do_level(nav_items[key])
      end
    elsif nav_items.instance_of?(Array)
      p 'obj is array' if ENV['debug']

      nav_items.each do |item|
        if item.instance_of?(Array)
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
