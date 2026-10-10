# frozen_string_literal: true

require_relative '../test_helper'
require 'open3'

class SuppliedBasketsTest < Minitest::Test
  include TestSupport

  EXECUTABLE_PATH = File.join(TestSupport::ROOT, 'bin', 'sales_tax')

  def run_executable(*command_line_arguments, stdin_text: '')
    Open3.capture3(RbConfig.ruby, EXECUTABLE_PATH, *command_line_arguments, stdin_data: stdin_text)
  end

  def expected_output(basket_number) = File.read(data_file("output#{basket_number}.txt"))

  (1..3).each do |basket_number|
    define_method("test_basket_#{basket_number}") do
      output, errors, status = run_executable(data_file("input#{basket_number}.txt"))
      assert status.success?, errors
      assert_equal expected_output(basket_number), output
    end
  end

  def test_all_baskets_at_once
    input_files = (1..3).map { |basket_number| data_file("input#{basket_number}.txt") }
    output, = run_executable(*input_files)

    expected_receipts = (1..3).map { |basket_number| "Output #{basket_number}:\n#{expected_output(basket_number)}" }
    assert_equal expected_receipts.join("\n"), output
  end

  def test_basket_from_stdin
    output, = run_executable(stdin_text: File.read(data_file('input2.txt')))
    assert_equal expected_output(2), output
  end
end
