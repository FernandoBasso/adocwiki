require_relative 'html_view_helpers'

class HtmlRenderContext
  include HtmlViewHelpers

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

