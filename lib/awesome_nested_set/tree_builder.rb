module CollectiveIdea #:nodoc:
  module Acts #:nodoc:
    module NestedSet #:nodoc:
      class TreeBuilder
        def initialize(sorted_elements)
          @sorted_elements = sorted_elements
        end

        def tree
          return nil if @sorted_elements.blank?
          @i = 0
          tree_helper(@sorted_elements.first)
        end

        def tree_helper(category)
          @i += 1
          return category if category.leaf?

          childs = []
          while (@sorted_elements[@i] && @sorted_elements[@i].rgt < category.rgt) do
            childs << tree_helper(@sorted_elements[@i])
          end
          category.children.target = childs
          category
        end
        private :tree_helper

        def self.tree(sorted_elements)
          self.new(sorted_elements).tree
        end
      end
    end
  end
end