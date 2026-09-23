require 'spec_helper'
require 'erb'

RSpec.describe AdocWiki::HtmlRenderContext do
  it 'correct makes context ivars available in the templates' do
    context = AdocWiki::HtmlRenderContext.new(
      config: { site_title: 'Site' },
      adoc: nil,
      side_nav: nil,
    )
    template = "<h1><%= @config[:site_title] %></h1>"
    renderer = ERB.new(template)
    output = renderer.result(context.get_binding)

    expect(output).to eq('<h1>Site</h1>')
  end
end
