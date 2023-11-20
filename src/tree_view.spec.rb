# frozen_string_literal: true

require 'awesome_print'
require 'yaml'
require_relative 'tree_view'

def _ap(acc)
  ap acc, indent: -2
end

describe TreeView do
  describe '#nav_items()' do
    it 'handles one-level items' do
      docsdir = "#{__dir__}/../test-data"
      nav = YAML.load_file("#{docsdir}/nav1.yml")
      tree = TreeView.new(nav, docsdir).nav_items

      expect(tree).to eq(
        {
          'Command Line' => [
            {
              path: 'cmdline/bash',
              title: 'bash',
              subtitle: nil
            },
            {
              path: 'cmdline/parameter-expansion',
              title: 'Parameter Expansion',
              subtitle: 'Bash :: Command Line'
            }
          ]
        }
      )
    end

    it 'handles two-level nested items' do
      docsdir = "#{__dir__}/../test-data"
      nav = YAML.load_file("#{docsdir}/nav2.yml")

      expect(TreeView.new(nav, docsdir).nav_items).to eq(
        {
          'Command Line' => [
            {
              path: 'cmdline/bash',
              title: 'bash',
              subtitle: nil
            },
            {
              path: 'cmdline/parameter-expansion',
              title: 'Parameter Expansion',
              subtitle: 'Bash :: Command Line'
            },
            'sed' => [
              {
                path: 'cmdline/sed/intro',
                title: 'Sed Introduction',
                subtitle: 'sed :: Command Line'
              },
              {
                path: 'cmdline/sed/the-s-command',
                title: 'The s Command',
                subtitle: 'sed :: Command Line'
              }
            ]
          ]
        }
      )
    end
  end
end
