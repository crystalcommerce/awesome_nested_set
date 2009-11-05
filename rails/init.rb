require 'awesome_nested_set'

ActiveRecord::Base.class_eval do
  include CollectiveIdea::Acts::NestedSet
end

if defined?(ActionView)
  require 'awesome_nested_set/helper'
  require 'awesome_nested_set/tree_builder'
  ActionView::Base.class_eval do
    include CollectiveIdea::Acts::NestedSet::Helper
  end
end