# frozen_string_literal: true

require_relative '../test_helper'

class MoneyTest < Minitest::Test
  def round(unrounded_tax_text) = SalesTax::Money.round_up_to_nickel(BigDecimal(unrounded_tax_text))

  def test_rounds_up_to_next_nickel
    assert_equal BigDecimal('1.50'), round('1.499')
    assert_equal BigDecimal('4.20'), round('4.1985')
    assert_equal BigDecimal('0.60'), round('0.5625')
  end

  def test_keeps_exact_multiples_and_zero
    assert_equal BigDecimal('7.15'), round('7.15')
    assert_equal BigDecimal('0'), round('0')
  end

  def test_formats_with_two_decimals
    assert_equal '1.50', SalesTax::Money.format(BigDecimal('1.5'))
    assert_equal '10.00', SalesTax::Money.format(BigDecimal('10'))
    assert_equal '98.38', SalesTax::Money.format(BigDecimal('98.38'))
  end
end
