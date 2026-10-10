# frozen_string_literal: true

module SalesTax
  module Models
    Item = Data.define(:quantity, :name, :unit_price, :imported, :exempt) do
      def imported? = imported
      def exempt? = exempt
    end
  end
end
