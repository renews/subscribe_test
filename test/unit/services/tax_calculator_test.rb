# frozen_string_literal: true

require 'test_helper'

class TaxCalculatorTest < Minitest::Test
  include TestSupport

  def setup
    @tax_calculator = SalesTax::Services::TaxCalculator.new
  end

  def test_exempt_product_has_no_tax
    basket_item = build_item(name: 'book', unit_price: '12.49', exempt: true)
    assert_equal BigDecimal('0'), @tax_calculator.unit_tax(basket_item)
  end

  def test_basic_tax
    basket_item = build_item(name: 'music CD', unit_price: '14.99')
    assert_equal BigDecimal('1.50'), @tax_calculator.unit_tax(basket_item)
  end

  def test_import_duty_on_exempt_product
    basket_item = build_item(name: 'imported box of chocolates', unit_price: '10.00', imported: true, exempt: true)
    assert_equal BigDecimal('0.50'), @tax_calculator.unit_tax(basket_item)
  end

  def test_basic_tax_plus_import_duty
    basket_item = build_item(name: 'imported bottle of perfume', unit_price: '47.50', imported: true)
    assert_equal BigDecimal('7.15'), @tax_calculator.unit_tax(basket_item)
  end

  def test_tax_is_rounded_per_unit
    basket_item = build_item(name: 'imported boxes of chocolates', unit_price: '11.25', quantity: 3,
                             imported: true, exempt: true)
    assert_equal BigDecimal('1.80'), @tax_calculator.line_tax(basket_item)
    assert_equal BigDecimal('35.55'), @tax_calculator.line_total(basket_item)
  end
end
