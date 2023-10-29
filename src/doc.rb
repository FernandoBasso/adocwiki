class Doc
  attr_reader :path_orig, :path_parts

  def initialize(file)
    @path_orig = file
    @path_parts = file.split('/')
  end


  ##
  # Returns that base path without the filename.
  #
  # Example:
  #
  #   ./my/notes/intro.adoc
  #
  # Becomes
  #
  #   ['.', 'my', 'notes']
  #
  # @return {string}
  #
  def path_base
    @path_parts[0 .. -2].join('/')
  end
end

