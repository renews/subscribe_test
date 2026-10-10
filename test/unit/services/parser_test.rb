# frozen_string_literal: true

require 'test_helper'

class ParserTest < Minitest::Test
  include TestSupport

  def setup
    @parser = SalesTax::Services::Parser.new
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

  def test_raises_invalid_product_name
    ['1  at 10.00', '1    at 10.00', "1 \t at 10.00"].each do |basket_line|
      parse_error = assert_raises(SalesTax::ParseError, basket_line) do
        @parser.parse("1 book at 1.00\n#{basket_line}\n")
      end
      assert_equal "invalid item on line 2: #{basket_line.inspect}", parse_error.message
    end
  end

  def test_parses_uppercase_products_from_defective_basket
    basket_lines = File.readlines(data_file('input_4.txt'))
    perfume, chocolates = @parser.parse(basket_lines.values_at(0, 2).join)

    assert_equal 'IMPORTED bottle of perfume', perfume.name
    assert_predicate perfume, :imported?
    refute_predicate perfume, :exempt?
    assert_equal 'imported boxes of CHOCOLATES', chocolates.name
    assert_predicate chocolates, :imported?
    assert_predicate chocolates, :exempt?
  end

  def test_rejects_blank_product_name_from_defective_basket
    basket_line = File.readlines(data_file('input_4.txt'), chomp: true).fetch(3)

    parse_error = assert_raises(SalesTax::ParseError) { @parser.parse_line(basket_line, 4) }
    assert_equal 'invalid item on line 4: "1     at 18.99"', parse_error.message
  end
end
