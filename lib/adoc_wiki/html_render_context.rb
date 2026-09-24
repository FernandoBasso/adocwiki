# SPDX-License-Identifier: GPL-3.0-or-later

module AdocWiki
  ##
  # Provides data through ivars that are available in .erb templates.
  #
  class HtmlRenderContext
    def initialize(
      config:,
      adoc:,
      side_nav:
    )
      @config = config
      @adoc = adoc
      @side_nav = side_nav
    end

    ##
    # The the binding context so we have the ivars available
    # on the caller side. Specially useful for making them
    # available in .erb templates.
    #
    # Example usage:
    #
    # ```ruby
    # context = AdocWiki::HtmlRenderContext.new(
    #   config: { site_title: "Site" },
    #   adoc: nil,
    #   side_nav: nil
    # )
    # template = "<h1><%= @config[:site_title] %></h1>"
    # renderer = ERB.new(template)
    # output = renderer.result(context.get_binding)
    #
    # expect(output).to eq("<h1>Site</h1>")
    # ```
    #
    def get_binding
      binding
    end
  end
end
