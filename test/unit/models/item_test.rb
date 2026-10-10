# frozen_string_literal: true

require 'test_helper'

class ItemTest < Minitest::Test
  include TestSupport

  def test_predicates
    basket_item = build_item(name: 'imported book', unit_price: '1.00', imported: true, exempt: true)
    assert_predicate basket_item, :imported?
    assert_predicate basket_item, :exempt?
  end

  def test_keeps_its_name_when_the_original_string_changes
    product_name = String.new('book')
    basket_item = build_item(name: product_name, unit_price: '1.00')

    product_name.replace('music CD')

    assert_equal 'book', basket_item.name
  end

  def test_name_cannot_be_changed_through_the_item
    basket_item = build_item(name: String.new('book'), unit_price: '1.00')

    assert_raises(FrozenError) { basket_item.name.replace('music CD') }
    assert_equal 'book', basket_item.name
  end
end
