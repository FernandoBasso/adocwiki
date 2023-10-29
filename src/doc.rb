# frozen_string_literal: true

##
# An AsciiDoc document file instance.
#
# This is a class that knows stuff about an `.adoc` file.
#
class Doc
  attr_reader :path_orig, :path_parts

  ##
  # @param {string} file
  #
  def initialize(file)
    @path_orig = file
    @path_parts = file.split('/')
  end

  ##
  # Returns that base path without the filename.
  #
  # An input like:
  #
  #     ./my/notes/intro.adoc
  #
  # Results in:
  #
  #     './my/notes'
  #
  # @return {string}
  #
  def path_base
    @path_parts[0..-2].join('/')
  end
end
