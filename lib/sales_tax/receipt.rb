# frozen_string_literal: true

module SalesTax
  class Receipt
    def initialize(basket_items, tax_calculator: TaxCalculator.new)
      @basket_items = basket_items
      @tax_calculator = tax_calculator
    end

    def sales_taxes = @basket_items.sum(Money::ZERO) { |basket_item| @tax_calculator.line_tax(basket_item) }

    def total = @basket_items.sum(Money::ZERO) { |basket_item| @tax_calculator.line_total(basket_item) }

    def lines
      item_lines = @basket_items.map do |basket_item|
        "#{basket_item.quantity} #{basket_item.name}: #{Money.format(@tax_calculator.line_total(basket_item))}"
      end
      [*item_lines, "Sales Taxes: #{Money.format(sales_taxes)}", "Total: #{Money.format(total)}"]
    end

    def to_s = lines.join("\n")
  end
end
