require_relative 'html_view_helpers'

describe HtmlViewHelpers do
  let(:helper) do
    Class.new {
      include HtmlViewHelpers
    }.new
  end

  base_data = {
    site_title: 'Site'
  }

  it 'handles the bare site title' do
    expect(helper.title(base_data)).to eq('Site')
  end
end
