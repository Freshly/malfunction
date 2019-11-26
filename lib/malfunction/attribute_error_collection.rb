# frozen_string_literal: true

module Malfunction
  class AttributeErrorCollection < Collectible::CollectionBase
    ensures_item_class AttributeError
  end
end
