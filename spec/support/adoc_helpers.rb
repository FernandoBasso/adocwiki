require "fileutils"

module AdocHelpers
  ##
  # Writes a file with the given content as `filename`.
  #
  # ## Params
  #
  # ### filename
  #
  # A `String` indicating the path + the name to write the file to. E.g.:
  #
  # - tmp/foo.bar.adoc`
  # - sample.adoc
  #
  #  The file path is always relative to the root directory of the project.
  #
  def h_write_file(filename, content)
    FileUtils.mkdir_p(Pathname.new(filename).dirname.to_path)
    File.write(filename, content)
  end

  ##
  # ## Params
  #
  # ### path
  #
  # A `String` representing the path to remove the directory recursively. E.g.:
  #
  # - tmp/foo/bar
  #
  #  The path is always relative to the root directory of the project.
  #
  def h_rm_r(path)
    FileUtils.rm_r(path)
  end
end
