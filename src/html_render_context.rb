require_relative 'html_view_helpers'

class HtmlRenderContext
  include HtmlViewHelpers

  def initialize(data)
    @data = data
  end

  def get_binding
    binding
  end
end

