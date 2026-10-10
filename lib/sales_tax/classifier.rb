# frozen_string_literal: true

module SalesTax
  class Classifier
    EXEMPT_PRODUCT_PATTERN = /\b(book|chocolate|pill)s?\b/i
    IMPORTED_PATTERN = /\bimported\b/i

    def imported?(product_name) = IMPORTED_PATTERN.match?(product_name)

    def exempt?(product_name) = EXEMPT_PRODUCT_PATTERN.match?(product_name)
  end
end
