# frozen_string_literal: true

require 'awesome_print'
require 'yaml'
require_relative 'tree_view'

def _ap(obj)
  ap obj, indent: 2
end

describe TreeView do
  it 'single level items' do
    navitems = <<~NAVITEMS
      Databases:
        - dbsql/intro.adoc
        - dbsql/psql-cli.adoc
    NAVITEMS

    nav = YAML.safe_load(navitems)

    expect(TreeView.new(nav).nav_items).to eq(
      {
        'Databases' => [
          {
            path: 'dbsql/intro'
            # title: 'Intro',
            # subtitle: nil
          },
          {
            path: 'dbsql/psql-cli'
            # title: 'psql CLI',
            # subtitle: nil'
          }
        ]
      }
    )
  end
end
