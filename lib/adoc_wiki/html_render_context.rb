# SPDX-License-Identifier: GPL-3.0-or-later

module AdocWiki
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

    def get_binding
      binding
    end
  end
end
