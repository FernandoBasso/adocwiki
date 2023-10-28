# rubocop:disable all

require 'yaml'
require 'fileutils'
require 'asciidoctor'
require 'erb'

class AdocWiki
  def initialize(nav_file_path)
    @nav_items = YAML.load_file(nav_file_path)
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
    "#{__dir__}/templates"
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
    path = "#{templates_path}/#{type}.html.erb"

    return path if File.exist?(path)

    raise "No template type “#{type}”."
  end

  ##
  # Converts an Asciidoc file to html and embeds it into the template.
  #
  # @param {string} adoc_file
  #
  def conv(adoc_file)
    rhtml = ERB.new(File.read(template_for('article'), mode: 'r:utf-8'))

    arr = adoc_file.split('/')

    ##
    # Drop filename and retain only the directory components.
    #
    dirs = arr[0 .. -2]

    ##
    # Prepend ‘build’ to the path.
    #
    dirs.insert(0, 'build')

    ##
    # Get the basename (filename without preceending dirs) only.
    #
    outname = arr[-1]

    FileUtils.mkpath(dirs.join('/'))

    adoc = Asciidoctor.load_file(adoc_file)

    ##
    # `adoc` variable will be available inside the template as `adoc`
    #
    html_page = rhtml.result(binding)

    File.write(
      "#{dirs.join('/')}/#{outname.gsub(/adoc$/, 'html')}",
      html_page,
    )

    p adoc.attributes['stem']
  end

  def do_level(nav_items = @nav_items)
    if nav_items.class == Hash
      puts 'obj is hash'

      nav_items.each_pair do |key, val|
        if nav_items[key].class == Array
          do_level(nav_items[key])
        else
          do_level(nav_items[key])
        end
      end
    elsif nav_items.class == Array
      puts 'obj is array'

      nav_items.each do |item|
        if item.class == Array
          do_level(item)
        else
          conv(item)
        end
      end
    else
      puts 'what‽'
    end
  end

  def copy_styles
    FileUtils.cp_r(
      "#{__dir__}/_static",
      "#{__dir__}/../build/",
      noop: false,
      verbose: false,
    )
  end
end

adoc = AdocWiki.new('./nav.yml')
adoc.build
