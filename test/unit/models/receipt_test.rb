# frozen_string_literal: true

require 'test_helper'

class ReceiptTest < Minitest::Test
  include TestSupport

  def test_formats_lines_taxes_and_total
    basket_items = [
      build_item(name: 'book', unit_price: '12.49', quantity: 2, exempt: true),
      build_item(name: 'music CD', unit_price: '14.99')
    ]
    receipt = SalesTax::Models::Receipt.new(basket_items)

    assert_equal BigDecimal('1.50'), receipt.sales_taxes
    assert_equal BigDecimal('41.47'), receipt.total
    assert_equal ['2 book: 24.98', '1 music CD: 16.49', 'Sales Taxes: 1.50', 'Total: 41.47'], receipt.lines
  end

  def test_empty_receipt_has_zero_totals
    assert_equal "Sales Taxes: 0.00\nTotal: 0.00", SalesTax::Models::Receipt.new([]).to_s
  end
end
