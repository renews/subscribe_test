# frozen_string_literal: true

module SalesTax
  module Models
    Item = Data.define(:quantity, :name, :unit_price, :imported, :exempt) do
      def initialize(quantity:, name:, unit_price:, imported:, exempt:)
        super(quantity:, name: name.dup.freeze, unit_price:, imported:, exempt:)
      end

      def imported? = imported
      def exempt? = exempt
    end
  end
end
