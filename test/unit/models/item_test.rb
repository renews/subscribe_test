# frozen_string_literal: true

require 'test_helper'

class ItemTest < Minitest::Test
  include TestSupport

  def test_predicates
    basket_item = build_item(name: 'imported book', unit_price: '1.00', imported: true, exempt: true)
    assert_predicate basket_item, :imported?
    assert_predicate basket_item, :exempt?
  end

  def test_is_immutable
    assert_predicate build_item(name: 'book', unit_price: '1.00'), :frozen?
  end
end
