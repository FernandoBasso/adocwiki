# SPDX-License-Identifier: GPL-3.0-or-later

require "yaml"

RSpec.describe AdocWiki do
  it "has a a proper version number" do
    expect(AdocWiki::VERSION).to match(/\d+\.\d+\.\d+/)
  end
end
