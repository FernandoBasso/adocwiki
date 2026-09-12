require 'asciidoctor'
require_relative 'html_view_helpers'

describe HtmlViewHelpers do
  let(:helper) do
    Class.new {
      include HtmlViewHelpers
    }.new
  end

  doc = <<EOF
= Doc
:page-tags: foo bar

== Intro

First intro paragraph.
EOF

  config = {
    'site-title': 'Site',
  }

  describe '#title()' do
    it 'returns the bare site title' do
      adoc = Asciidoctor.load('')
      expect(helper.title(config: config, adoc: adoc)).to eq('Site')
    end

    it 'concats the doc title with the site title' do
      adoc = Asciidoctor.load(doc)

      expect(helper.title(config: config, adoc: adoc)).to eq('Doc :: Site')
    end

    it 'concats doc title, subject and site title' do
      adoc = Asciidoctor.load(doc)
      adoc.set_attribute('page-subject', 'Subject')

      expect(
        helper.title(config: config, adoc: adoc)
      ).to eq('Doc :: Subject :: Site')
    end

    it 'uses page-title instead of = Title' do
      adoc = Asciidoctor.load(doc)
      adoc.set_attribute('page-title', 'Page')

      expect(
        helper.title(
          config: config,
          adoc: adoc,
        )
      ).to eq('Page :: Site')

      adoc.set_attribute('page-subject', 'Subject')

      expect(
        helper.title(
          config: config,
          adoc: adoc,
        )
      ).to eq('Page :: Subject :: Site')
    end
  end

  describe '#doc_title()' do
    it 'renders the title from doc-title attribute when present' do
      adoc = Asciidoctor.load(doc)
      adoc.set_attribute('doc-title', 'My Doc Title')

      expect(
        helper.doc_title(adoc: adoc)
      ).to eq('My Doc Title')
    end

    it 'renders the default = Title when doc-title is not present' do
      adoc = Asciidoctor.load(doc)

      expect(
        helper.doc_title(adoc: adoc)
      ).to eq('Doc')
    end
  end

  describe '#doc_nav_title()' do
    it 'uses the doc-nav-title attribute' do
      adoc = Asciidoctor.load(doc)
      adoc.set_attribute('doc-nav-title', 'My Nav Title')

      expect(
        helper.doc_nav_title(adoc: adoc)
      ).to eq('My Nav Title')
    end

    it 'uses doc-title if available and doc-nav-title is not' do
      adoc = Asciidoctor.load(doc)
      adoc.set_attribute('doc-title', 'Doc Title')

      expect(
        helper.doc_nav_title(adoc: adoc)
      ).to eq('Doc Title')
    end

    it 'uses = Title if neither doc-nav-title or doc-title are available' do
      adoc = Asciidoctor.load(doc)

      expect(
        helper.doc_nav_title(adoc: adoc)
      ).to eq('Doc')
    end
  end
end
