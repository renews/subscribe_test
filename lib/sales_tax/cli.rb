# frozen_string_literal: true

module SalesTax
  class CLI
    USAGE = 'Usage: bin/sales_tax [basket_file ...]   (reads from STDIN when no file is given)'

    def initialize(input_stream: $stdin, output_stream: $stdout, error_stream: $stderr)
      @input_stream = input_stream
      @output_stream = output_stream
      @error_stream = error_stream
    end

    def run(command_line_arguments)
      case command_line_arguments
      in [*, '-h' | '--help', *]
        @output_stream.puts USAGE
      in []
        @output_stream.puts SalesTax.receipt_for(@input_stream.read)
      in [*basket_file_paths]
        @output_stream.puts receipts_for_files(basket_file_paths)
      end
      0
    rescue ParseError, SystemCallError => error
      @error_stream.puts "Error: #{error.message}"
      1
    end

    private

    def receipts_for_files(basket_file_paths)
      return SalesTax.receipt_for(File.read(basket_file_paths.first)) if basket_file_paths.one?

      basket_file_paths.each.with_index(1).map do |basket_file_path, basket_number|
        "Output #{basket_number}:\n#{SalesTax.receipt_for(File.read(basket_file_path))}"
      end.join("\n\n")
    end
  end
end
