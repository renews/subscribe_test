# frozen_string_literal: true

module SalesTax
  module Money
    ZERO = BigDecimal('0')
    ROUNDING_STEP = BigDecimal('0.05')

    module_function

    def round_up_to_nickel(unrounded_tax) = (unrounded_tax / ROUNDING_STEP).ceil * ROUNDING_STEP

    def format(amount) = Kernel.format('%.2f', amount)
  end
end
