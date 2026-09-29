# SPDX-License-Identifier: GPL-3.0-or-later

require_relative "../spec_helper"
require "fileutils"
require "nokogiri"

RSpec.describe AdocWiki::Builder do
  describe "#walk()" do
    it "walks a one-level sidebar" do
      config = <<~ASCIIDOC
        site_title: 'Site Title'
        content_dir: 'tmp/spec/content'
        dist_dir: 'tmp/spec/dist'
        nav:
          Command Line:
            - cmdline/bash.adoc
            - cmdline/sed.adoc
      ASCIIDOC

      builder = AdocWiki::Builder.new(config: config, root_dir: ".")

      allow(builder).to receive(:conv)

      expect(builder).to receive(:walk).with(no_args).once.and_call_original

      expect(builder).to receive(:walk)
        .with(["cmdline/bash.adoc", "cmdline/sed.adoc"])
        .once
        .and_call_original

      expect(builder).to receive(:conv).with("cmdline/bash.adoc").once
      expect(builder).to receive(:conv).with("cmdline/sed.adoc").once

      builder.walk
    end

    it "walks a two-level sidebar" do
      config = <<~ASCIIDOC
        site_title: 'Site Title'
        content_dir: 'tmp/spec/content'
        dist_dir: 'tmp/spec/dist'
        nav:
          Command Line:
            - cmdline/bash
            - SED:
              - cmdline/sed/intro.adoc
      ASCIIDOC

      builder = AdocWiki::Builder.new(config: config, root_dir: ".")

      allow(builder).to receive(:conv)

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

  describe "#conv()" do
    it "converts the file to AsciiDoc" do
      asciidoc_content = <<~ASCIIDOC
        = Title
        :foo: bar

        == Intro
        A paragraph.
      ASCIIDOC

      config = <<~CONFIG
        site_title: 'Site Title'
        content_dir: 'tmp/spec/docs'
        dist_dir: 'tmp/spec/dist'
        menu: []
        nav:
          Command Line:
            - cmdline/intro.adoc
      CONFIG

      builder = AdocWiki::Builder.new(config: config, root_dir: ".")

      h_write_file("tmp/spec/docs/cmdline/intro.adoc", asciidoc_content)

      returned_path = builder.conv("cmdline/intro.adoc")

      expect(returned_path).to eq("tmp/spec/dist/cmdline/intro.html")

      ##
      # And not to test Asciidoctor, but just some smoke test that
      # we actually converted to HTML instead of just writting
      # whatever file in that path.
      #
      dom = Nokogiri::HTML(File.open(returned_path))
      title = dom.css("head > title").text
      expect(title).to eq("Site Title")

      ##
      # Clean all up.
      #
      h_rm_r("./tmp/spec")
    end
  end
end
