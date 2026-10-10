# frozen_string_literal: true

require_relative '../test_helper'

class ParserTest < Minitest::Test
  def setup
    @parser = SalesTax::Parser.new
  end

  def test_parses_a_line
    basket_item = @parser.parse_line('3 imported boxes of chocolates at 11.25')
    assert_equal 3, basket_item.quantity
    assert_equal 'imported boxes of chocolates', basket_item.name
    assert_equal BigDecimal('11.25'), basket_item.unit_price
    assert_predicate basket_item, :imported?
    assert_predicate basket_item, :exempt?
  end

  def test_name_can_contain_at
    assert_equal 'hat at the beach', @parser.parse_line('1 hat at the beach at 5.00').name
  end

  def test_ignores_blank_lines
    basket_items = @parser.parse("1 book at 1.00\r\n\n1 music CD at 2.00\n")
    assert_equal ['book', 'music CD'], basket_items.map(&:name)
  end

  def test_empty_basket
    assert_raises(SalesTax::ParseError) { @parser.parse("\n\n") }
  end

  def test_invalid_lines
    ['book at 12.49', '0 book at 1.00', '1 book 12.49', '1 book at abc', '1 book at -1.00'].each do |basket_line|
      assert_raises(SalesTax::ParseError, basket_line) { @parser.parse_line(basket_line) }
    end
  end

  def test_error_shows_line_number
    parse_error = assert_raises(SalesTax::ParseError) { @parser.parse("1 book at 1.00\nbook 12.49\n") }
    assert_match(/line 2/, parse_error.message)
  end
end
