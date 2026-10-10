# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'minitest/autorun'
require 'stringio'
require 'sales_tax'

module TestSupport
  ROOT = File.expand_path('..', __dir__)
  DATA_DIR = File.join(ROOT, 'data')

  def data_file(file_name) = File.join(DATA_DIR, file_name)

  def build_item(name:, unit_price:, quantity: 1, imported: false, exempt: false)
    SalesTax::Models::Item.new(quantity:, name:, unit_price: BigDecimal(unit_price), imported:, exempt:)
  end
end
