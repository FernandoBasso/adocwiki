require_relative 'doc.rb'

describe Doc do
  it 'can return the original path' do
    doc = Doc.new('./my/notes/intro.adoc')

    expect(doc.path_orig).to eq './my/notes/intro.adoc'
  end

  it 'can return the path components' do
    doc = Doc.new('./my/notes/intro.adoc')

    expect(doc.path_parts).to eq(['.', 'my', 'notes', 'intro.adoc'])
  end

  it 'can return the base path' do
    doc = Doc.new('./my/notes/intro.adoc')

    expect(doc.path_base).to eq('./my/notes')
  end

end
