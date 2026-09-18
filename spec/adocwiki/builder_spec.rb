require "spec_helper"

RSpec.describe Adocwiki::Builder do
  it 'walks a one-level sidebar' do
    side_nav = <<~EOF
      Command Line:
        - cmdline/bash.adoc
        - cmdline/sed.adoc
    EOF

    builder = Adocwiki::Builder.new(side_nav:)

    expect(builder).to receive(:walk).with(no_args).once.and_call_original

    expect(builder).to receive(:walk)
      .with(["cmdline/bash.adoc", "cmdline/sed.adoc"])
      .once
      .and_call_original
    
    expect(builder).to receive(:conv)
      .with('cmdline/bash.adoc')
      .once
      .and_call_original

    expect(builder).to receive(:conv)
      .with('cmdline/sed.adoc')
      .once
      .and_call_original

    builder.walk()
  end
end
