require 'erb'

module HtmlViewHelpers
  def title(data)
    pp "==========="
    pp data
    pp "==========="
    return data[:site_title]
  end
end

