# frozen_string_literal: true

require 'awesome_print'
require 'yaml'
require_relative 'tree_view'

def _ap(acc)
  ap acc, indent: 2
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

  it 'multi level items' do
    navitems = <<~NAVITEMS
      Databases:
        - dbsql/intro.adoc
        - dbsql/psql-cli.adoc
      Editors:
        Vim:
          - editors/vim/getting-started.adoc
        Emacs:
          - editors/emacs/everyday-tips.adoc
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
        ],
        'Editors' => {
          'Vim' => [
            {
              path: 'editors/vim/getting-started'
              # title: 'Getting Started',
              # subtitle: nil
            }
          ],
          'Emacs' => [
            {
              path: 'editors/emacs/everyday-tips'
            }
          ]
        }
      }
    )
  end
end
