require "yaml"

module Adocwiki
  class Builder
    def initialize(side_nav:)
      @items = YAML.load(side_nav)
    end

    def conv(v)
      v
    end

    ##
    # ## Params
    #
    # ### items
    #
    # `items` is one of:
    #
    # - `Hash`
    # - `Array`
    # - `String`
    #
    # When a `Hash`, it contains an `Array`. When an `Array`, it contains
    # further `Hash` (indicating sub-categories) or `String`, , and when
    # `String`, it is a path to an `.adoc` file to be converted. These are
    # handed over to `#conv()`.
    #
    # ### Return
    #
    # `nil`
    #
    def walk(items = @items)
      ##
      # If a hash, then it contains an array of other hashes or
      # strings, or both.
      #
      if items.is_a?(Hash)
        items.each_pair do |key, _val|
          ##
          # Walk over the array items.
          #
          walk(items[key])
        end
      elsif items.is_a?(Array)
        ##
        # If an array, then it can contain Hash | String.
        #
        items.each do |item|
          ##
          # If a hash, then it contains an array of other hashes,
          # or strings, or both.
          #
          if item.is_a?(Hash)
            walk(item)
          else
            ##
            # Should be a string. A path to an .adoc file. Convert it!
            #
            conv(item)
          end
        end
      end
    end
  end
end
