# frozen_string_literal: true

module SalesTax
  class CLI
    def initialize(input_stream: $stdin, output_stream: $stdout, error_stream: $stderr)
      @input_stream = input_stream
      @output_stream = output_stream
      @error_stream = error_stream
    end

    def run(command_line_arguments)
      if command_line_arguments.empty?
        @output_stream.puts SalesTax.receipt_for(@input_stream.read)
      else
        @output_stream.puts receipts_for_files(command_line_arguments)
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
