# frozen_string_literal: true

require 'bigdecimal'

require_relative 'sales_tax/money'
require_relative 'sales_tax/item'
require_relative 'sales_tax/classifier'
require_relative 'sales_tax/tax_calculator'
require_relative 'sales_tax/parser'
require_relative 'sales_tax/receipt'
require_relative 'sales_tax/cli'

module SalesTax
  class ParseError < StandardError; end

  def self.receipt_for(basket_text) = Receipt.new(Parser.new.parse(basket_text)).to_s
end
