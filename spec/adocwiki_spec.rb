# SPDX-License-Identifier: GPL-3.0-or-later

require "yaml"

RSpec.describe Adocwiki do
  it "has a a proper version number" do
    expect(Adocwiki::VERSION).to match(/\d+\.\d+\.\d+/)
  end
end
