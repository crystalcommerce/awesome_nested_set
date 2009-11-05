require 'test/unit'
require 'rubygems'
require 'activesupport'
require File.dirname(__FILE__) + "/../../lib/awesome_nested_set/tree_builder"

module CollectiveIdea
  module Acts #:nodoc:
    module NestedSet #:nodoc:
      class TreeBuilderTest < Test::Unit::TestCase
        
        class MockNode
          class AssociationProxy
            attr_accessor :target
            def initialize
              @target = []
            end
          end
          
          attr_accessor :lft, :rgt, :name, :children
          
          def initialize(lft, rgt, name = "")
            @lft, @rgt = lft, rgt
            @name = name
            @children = AssociationProxy.new
          end
          
          def leaf?
            (self.rgt - self.lft) == 1
          end
          
          def inspect
            name
          end
        end
        
        def node(lft, rgt, name = "")
          MockNode.new(lft, rgt, name)
        end
  
        def test_a_leaf_should_return_itself
          root = node(1,2)
          tree = TreeBuilder.tree([root])
          assert_equal tree, root
        end
    
        def test_calling_on_an_empty_list_returns_nil
          tree = TreeBuilder.tree([])
          assert_equal nil, tree
        end

        def test_calling_on_a_3_node_list_works
          #           1(root)6
          #          /        \
          #   2(child_1)3  4(child_2)5
          root    = node(1,6)
          child_1 = node(2,3)
          child_2 = node(4,5)
          tree = TreeBuilder.tree([root, child_1, child_2])
          assert_equal root, tree
          assert_equal [child_1, child_2], tree.children.target
          assert_equal [], child_1.children.target
          assert_equal [], child_2.children.target
        end

        def test_calling_on_a_large_tree_works
          #                         1(root)18
          #                        /         \
          #                 2(c1)7            8(c4)17 _______
          #                /    \             |     \        \
          #          3(c2)4     5(c3)6    9(c5)10   11(c6)14  15(c8)16
          #                                            \
          #                                             12(c7)13
          root = node(1,18 , "root")
          c1   = node(2,7  , "c1")
          c2   = node(3,4  , "c2")
          c3   = node(5,6  , "c3")
          c4   = node(8,17 , "c4")
          c5   = node(9,10 , "c5")
          c6   = node(11,14, "c6")
          c7   = node(12,13, "c7")
          c8   = node(15,16, "c8")
          tree = TreeBuilder.tree([root, c1, c2, c3, c4, c5, c6, c7, c8])
          # debugger
          assert_equal root, tree
          assert_equal [c1, c4],     tree.children.target
          assert_equal [c2, c3],     c1.children.target
          assert_equal [],           c2.children.target
          assert_equal [],           c3.children.target
          assert_equal [c5, c6, c8], c4.children.target
          assert_equal [],           c5.children.target
          assert_equal [c7],         c6.children.target
          assert_equal [],           c7.children.target
          assert_equal [],           c8.children.target
        end
  
      end
    end
  end
end
