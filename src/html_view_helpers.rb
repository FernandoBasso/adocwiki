require 'erb'
##
# The `HtmlViewHelpers` module contains helper methods to derive pieces
# of text used in the templates, such as titles, outline, etc.
#
module HtmlViewHelpers
  ##
  # ## title()
  #
  # Returns a string with the title text that goes inside the `<title>` tag.
  #
  # When the document contains `= Title`, it is used, unless the document has
  # `page-title` attribute, in which case it takes precendence over `= Title`.
  #
  # If `page-subject` attribute exists, it gets added in between the doc or
  # page title and the site title.
  #
  # ### Examples
  #
  # If the document title is “Doc”, it has the `page-subject` set to “Subject”,
  # and the `site-title` in `adocwiki.yml` is set to “Site”, then the resulting
  # title is this:
  #
  # ```ruby
  # title(data)
  # #=> Doc :: Subject :: Site
  # ```
  #
  # ### Params
  #
  # `config:`
  # : The adocwiki config hash read from `adocwiki.yml`. Contains the
  # key `site-title`.
  #
  # `adoc:`
  # : An instance of Asciidoctor. Includes methods like `title` and, importantly,
  # an `attributes` hash with keys like `page-title` and `page-subject`.
  #
  # ### Return
  #
  # Returns the title `String` with the concatenation of the available
  # title-related data taken from the params.
  #
  def title(config:, adoc:)
    site_title = config[:'site-title']
    doc_title = adoc.title
    page_title = adoc.attributes['page-title']
    page_subject = adoc.attributes['page-subject']

    doc_or_page_title = page_title || doc_title

    [doc_or_page_title, page_subject, site_title].compact.join(' :: ')
  end

  ##
  # ## doc_title()
  #
  # Returns the title to show inside the `<h1>` tag of the page.
  #
  # Tries the `doc-title` attribute if available, or default to the
  # title taken from the `= Title` markup.
  #
  # ### Params
  #
  # `adoc:`
  # : An instance of `Asciidoctor`.
  #
  # ### Return
  #
  # A `String`.
  #
  def doc_title(adoc:)
    adoc.attributes['doc-title'] || adoc.title
  end

  ##
  # ## doc_nav_title()
  #
  # Returns the document title to be displayed in the navigation sidebar.
  #
  # Chooses the title in this order of precedence:
  #
  # 1. `doc-nav-title` attribute.
  # 2. `doc-title` attribute.
  # 3. `= Title` markup.
  #
  # ### Params
  #
  # `adoc:`
  # : An instance of `Asciidoctor`.
  #
  # ### Return
  #
  # A `String`.
  #
  def doc_nav_title(adoc:)
    adoc.attributes['doc-nav-title'] ||
      adoc.attributes['doc-title'] ||
      adoc.title
  end
end
