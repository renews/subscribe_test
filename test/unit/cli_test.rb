# frozen_string_literal: true

require 'test_helper'

class CLITest < Minitest::Test
  include TestSupport

  def run_cli(command_line_arguments, stdin_text: '')
    output_stream = StringIO.new
    error_stream = StringIO.new
    exit_status = SalesTax::CLI.new(
      input_stream: StringIO.new(stdin_text), output_stream:, error_stream:
    ).run(command_line_arguments)
    [exit_status, output_stream.string, error_stream.string]
  end

  def test_reads_from_stdin
    exit_status, output, = run_cli([], stdin_text: "1 music CD at 14.99\n")
    assert_equal 0, exit_status
    assert_equal "1 music CD: 16.49\nSales Taxes: 1.50\nTotal: 16.49\n", output
  end

  def test_labels_each_receipt_when_given_several_files
    exit_status, output, = run_cli([data_file('input1.txt'), data_file('input2.txt')])
    assert_equal 0, exit_status
    assert_match(/\AOutput 1:\n2 book: 24\.98/, output)
    assert_match(/\n\nOutput 2:\n1 imported box of chocolates: 10\.50/, output)
  end

  def test_missing_file
    exit_status, _output, errors = run_cli(['missing.txt'])
    assert_equal 1, exit_status
    assert_match(/No such file/, errors)
  end

  def test_invalid_input
    exit_status, _output, errors = run_cli([], stdin_text: "not a valid line\n")
    assert_equal 1, exit_status
    assert_match(/\AError: invalid item on line 1/, errors)
  end
end
