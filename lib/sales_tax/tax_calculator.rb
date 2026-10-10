# frozen_string_literal: true

module SalesTax
  class TaxCalculator
    NO_TAX = BigDecimal('0')
    BASIC_RATE = BigDecimal('0.10')
    IMPORT_RATE = BigDecimal('0.05')

    def tax_rate(basket_item)
      case basket_item
      in { exempt: true, imported: true } then IMPORT_RATE
      in { exempt: true, imported: false } then NO_TAX
      in { exempt: false, imported: true } then BASIC_RATE + IMPORT_RATE
      in { exempt: false, imported: false } then BASIC_RATE
      end
    end

    def unit_tax(basket_item) = Money.round_up_to_nickel(basket_item.unit_price * tax_rate(basket_item))

    def line_tax(basket_item) = unit_tax(basket_item) * basket_item.quantity

    def line_total(basket_item) = (basket_item.unit_price * basket_item.quantity) + line_tax(basket_item)
  end
end
