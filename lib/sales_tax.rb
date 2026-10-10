# frozen_string_literal: true

require 'bigdecimal'

require_relative 'sales_tax/utils/money'
require_relative 'sales_tax/models/item'
require_relative 'sales_tax/models/receipt'
require_relative 'sales_tax/services/classifier'
require_relative 'sales_tax/services/tax_calculator'
require_relative 'sales_tax/services/parser'
require_relative 'sales_tax/cli'

module SalesTax
  class ParseError < StandardError; end

  def self.receipt_for(basket_text) = Models::Receipt.new(Services::Parser.new.parse(basket_text)).to_s
end
