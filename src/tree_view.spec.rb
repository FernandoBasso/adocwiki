# frozen_string_literal: true

require 'awesome_print'
require 'yaml'
require_relative 'tree_view'

def _ap(acc)
  ap acc, indent: 2
end

describe TreeView do
  it 'can work with multi-level items' do
    nav = YAML.load_file("#{__dir__}/../test-data/nav.yml")

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
            },
            {
              path: 'editors/vim/coc'
              # title: 'Getting Started',
              # subtitle: nil
            }
          ],
          'Emacs' => [
            {
              path: 'editors/emacs/intro'
            }
          ]
        },
        'Miscellanous' => [
          {
            path: 'misc/archlinux'
          },
          {
            path: 'misc/asciidoc'
          }
        ]
      }
    )
  end
end
