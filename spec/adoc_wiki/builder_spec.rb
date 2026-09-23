# SPDX-License-Identifier: GPL-3.0-or-later

require "spec_helper"

RSpec.describe AdocWiki::Builder do
  describe "#walk()" do
    it "walks a one-level sidebar" do
      side_nav = <<~ASCIIDOC
        Command Line:
          - cmdline/bash.adoc
          - cmdline/sed.adoc
      ASCIIDOC

      builder = AdocWiki::Builder.new(side_nav:)

      expect(builder).to receive(:walk).with(no_args).once.and_call_original

      expect(builder).to receive(:walk)
        .with(["cmdline/bash.adoc", "cmdline/sed.adoc"])
        .once
        .and_call_original

      expect(builder).to receive(:conv)
        .with("cmdline/bash.adoc")
        .once
        .and_call_original

      expect(builder).to receive(:conv)
        .with("cmdline/sed.adoc")
        .once
        .and_call_original

      builder.walk
    end

    it "walks a two-level sidebar" do
      side_nav = <<~ASCIIDOC
        Command Line:
          - cmdline/bash
          - SED:
            - cmdline/sed/intro.adoc
      ASCIIDOC

      builder = AdocWiki::Builder.new(side_nav:)

      expect(builder).to receive(:walk).with(no_args).once.and_call_original

      expect(builder).to receive(:walk)
        .with(["cmdline/bash", { "SED" => ["cmdline/sed/intro.adoc"] }])
        .once
        .and_call_original

      expect(builder).to receive(:conv)
        .with("cmdline/bash")
        .once

      expect(builder).to receive(:walk)
        .with({ "SED" => ["cmdline/sed/intro.adoc"] })
        .once
        .and_call_original

      expect(builder).to receive(:walk)
        .with(["cmdline/sed/intro.adoc"])
        .once
        .and_call_original

      expect(builder).to receive(:conv)
        .with("cmdline/sed/intro.adoc")
        .once

      builder.walk
    end
  end
end
