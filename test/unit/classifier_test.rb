# frozen_string_literal: true

require_relative '../test_helper'

class ClassifierTest < Minitest::Test
  def setup
    @classifier = SalesTax::Classifier.new
  end

  def test_imported
    assert @classifier.imported?('imported box of chocolates')
    assert @classifier.imported?('box of imported chocolates')
    refute @classifier.imported?('bottle of perfume')
  end

  def test_books_food_and_medical_products_are_exempt
    ['book', 'chocolate bar', 'imported boxes of chocolates', 'packet of headache pills'].each do |product_name|
      assert @classifier.exempt?(product_name), product_name
    end
  end

  def test_other_products_are_not_exempt
    ['music CD', 'bottle of perfume', 'bookshelf'].each do |product_name|
      refute @classifier.exempt?(product_name), product_name
    end
  end
end
