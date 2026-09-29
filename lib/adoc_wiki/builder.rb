# SPDX-License-Identifier: GPL-3.0-or-later

require "yaml"
require "asciidoctor"

module AdocWiki
  ##
  # Responsible for walking over the navigation structure to convert
  # the files to HTML.
  #
  class Builder
    ##
    # ### Params
    #
    # #### config:
    #
    # A YAML `String` with configs from adocwiki.yml.
    #
    # #### root_dir:
    #
    # A `String` representing the root directory of the project to be
    # converted to the website. All other directories are derived from
    # that root directory, so docs and dist directories will be inside
    # that root directory as well.
    #
    def initialize(config:, root_dir:)
      @config = YAML.load(config)
      @nav = @config["nav"]
      @root_dir = root_dir
      @content_dir = @config["content_dir"]
      @dist_dir = @config["dist_dir"]
    end

    ##
    # ## #walk()
    #
    # Navigates the nav items to generate the site file structure.
    #
    # ### Params
    #
    # #### items
    #
    # `items` is one of:
    #
    # - `Hash`
    # - `Array`
    # - `String`
    #
    # When a `Hash`, it contains an `Array`. When an `Array`, it contains
    # either `Hash` (indicating sub-categories) and/or `String` elements, and
    # when `String`, it is a path to an `.adoc` file to be converted. These are
    # handed over to `#conv()`.
    #
    # #### Return
    #
    # The value returned by `#conv()`.
    #
    def walk(items = @nav)
      ##
      # If a hash, then it contains an array of other hashes or
      # strings, or both.
      #
      if items.is_a?(Hash)
        items.each_pair do |key, _val|
          ##
          # Walk over the array items.
          #
          walk(items[key])
        end
      elsif items.is_a?(Array)
        ##
        # If an array, then it can contain Hash | String.
        #
        items.each do |item|
          ##
          # If a hash, then it contains an array of other hashes,
          # or strings, or both.
          #
          if item.is_a?(Hash)
            walk(item)
          else
            ##
            # Should be a string. A path to an .adoc file. Convert it!
            #
            conv(item)
          end
        end
      end
    end

    ##
    # ## #conv()
    #
    # Converts a given .adoc file to its final HTML output. For example, given
    # this `adocwiki.yml`:
    #
    # ```yaml
    # nav:
    #   Command Line:
    #     - cmdline/bash.adoc
    #     - cmdline/sed.adoc
    # ```
    #
    # Which means we have these .adoc files:
    #
    # - "docs/cmdline/intro.cmd"
    # - "docs/cmdline/sed/getting-started.adoc"
    #
    # Get converted to .html and and writen to the build directory:
    #
    # - "build/cmdline/intro.html
    # - "build/cmdline/sed/getting-started.html"
    # ### Params
    #
    # #### file
    #
    # A `String` indicating the path to an`.adoc` file to be converted, e.g.:
    #
    # ### Return
    #
    # A `String` representing the path of the converted file.
    #
    def conv_x(adoc_file)
      adoc_file
    end

    def conv(adoc_file)
      content_path = File.join(@root_dir, @content_dir)
      adoc = Asciidoctor.load_file(
        "#{content_path}/#{adoc_file}",
        attributes: {
          "source-highlighter" => "pygments",
          "sectlinks" => true,
          "sectlevels" => 6,
          "icons" => "font"
        }
      )

      template = ERB.new(
        File.read("#{__dir__}/../templates/article.html.erb", mode: "r:utf-8")
      )
      file = Pathname.new(adoc_file)
      dist_path = File.join(@root_dir, @dist_dir, file.dirname.to_path)

      FileUtils.mkpath(dist_path)

      context = HtmlRenderContext.new(config: @config, adoc: adoc)

      html_page = template.result(context.get_binding)
      # html_path = "#{@root_dir}/#{@dist_dir}/#{file.dirname.to_path}/#{file.basename.to_path.gsub(/.adoc$/, ".html")}"
      html_path = Pathname.new(File.join(dist_path, file.basename.to_path.gsub(/\.adoc$/, ".html"))).cleanpath.to_path

      File.write(html_path, html_page)

      html_path
    end
  end
end
