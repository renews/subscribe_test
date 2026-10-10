# frozen_string_literal: true

module SalesTax
  module Models
    class Receipt
      def initialize(basket_items, tax_calculator: Services::TaxCalculator.new)
        @basket_items = basket_items.dup.freeze
        @tax_calculator = tax_calculator
      end

      def sales_taxes = @basket_items.sum(Utils::Money::ZERO) { |basket_item| @tax_calculator.line_tax(basket_item) }

      def total = @basket_items.sum(Utils::Money::ZERO) { |basket_item| @tax_calculator.line_total(basket_item) }

      def lines
        item_lines = @basket_items.map do |basket_item|
          "#{basket_item.quantity} #{basket_item.name}: #{Utils::Money.format(@tax_calculator.line_total(basket_item))}"
        end
        [*item_lines, "Sales Taxes: #{Utils::Money.format(sales_taxes)}", "Total: #{Utils::Money.format(total)}"]
      end

      def to_s = lines.join("\n")
    end
  end
end
