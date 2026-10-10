# frozen_string_literal: true

module SalesTax
  class Parser
    LINE_PATTERN = /\A(?<quantity>\d+) (?<name>.+) at (?<price>\d+(?:\.\d{1,2})?)\z/

    def initialize(product_classifier: Classifier.new)
      @product_classifier = product_classifier
    end

    def parse(basket_text)
      basket_lines = basket_text.scrub.each_line.map(&:strip)
      basket_items = basket_lines.each.with_index(1).filter_map do |basket_line, line_number|
        parse_line(basket_line, line_number) unless basket_line.empty?
      end
      raise ParseError, 'the basket is empty' if basket_items.empty?

      basket_items
    end

    def parse_line(basket_line, line_number = 1)
      case LINE_PATTERN.match(basket_line)
      in { quantity: quantity_text, name: product_name, price: price_text } if quantity_text.to_i.positive?
        Item.new(
          quantity: quantity_text.to_i,
          name: product_name,
          unit_price: BigDecimal(price_text),
          imported: @product_classifier.imported?(product_name),
          exempt: @product_classifier.exempt?(product_name)
        )
      else
        raise ParseError, "invalid item on line #{line_number}: #{basket_line.inspect}"
      end
    end
  end
end
