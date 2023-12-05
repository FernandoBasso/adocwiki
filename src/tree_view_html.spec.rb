# frozen_string_literal: true

require 'awesome_print'
require 'yaml'
require 'nokogiri'
require_relative 'tree_view_html'

def _ap(acc)
  ap acc, indent: -2
end

describe TreeViewHtml do
  describe '#nav_html()' do
    it 'generates single-level navigation structure' do
      tree = {
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

      html = TreeViewHtml.new(tree).nav_html
      dom = Nokogiri::HTML(html)

      expect(dom.css('ul.navtree').size).to eq(1)
      expect(dom.css('ul li.category').size).to eq(1)

      links = dom.css('ul.navtree li.category ul li a[href]')

      expect(links.size).to eq(2)

      expect(links.first.text).to eq('bash')
      expect(
        links.first.attribute('href').value
      ).to eq('/cmdline/bash.html')

      expect(links.last.text).to eq('Parameter Expansion')
      expect(
        links.last.attribute('href').value
      ).to eq('/cmdline/parameter-expansion.html')
    end

    it 'generates two-level navigation structure' do
      tree = {
        'Command Line' => [
          {
            path: 'cmdline/bash',
            title: 'bash',
            subtitle: nil
          }
        ],
        'Editors' => [
          'Vim' => [
            {
              path: 'editors/vim/getting-started',
              title: 'Getting Started',
              subtitle: nil
            }
          ]
        ]
      }

      html = TreeViewHtml.new(tree).nav_html
      dom = Nokogiri::HTML(html, &:noblanks)

      expect(dom.css('ul.navtree').size).to eq(1)
      expect(dom.css('ul.navtree > li.category').size).to eq(2)
      expect(dom.css('ul.navtree > li.category > button').first.text).to eq('Command Line')
      expect(dom.css('ul.navtree > li.category > button').last.text).to eq('Editors')

      editors = dom.css('ul.navtree > li.category').last

      expect(editors.css('button').first.text).to eq('Editors')

      expect(editors.css('ul.items > li.category > button').text).to eq('Vim')
      expect(editors.css('ul.items > li.category > ul.items > li > a').text).to eq('Getting Started')
      expect(
        editors.css('ul.items > li.category > ul.items > li > a')
        .attribute('href').value
      ).to eq('/editors/vim/getting-started.html')
    end
  end
end
