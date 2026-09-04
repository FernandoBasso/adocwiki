require 'erb'
require_relative 'html_render_context'

describe HtmlRenderContext do
  it 'renders the bare site title' do
    context = HtmlRenderContext.new({ site_title: 'Site'})
    template = "<%= title(@data) %>"
    renderer = ERB.new(template)
    output = renderer.result(context.get_binding)

    expect(output).to eq('Site')
  end
end
