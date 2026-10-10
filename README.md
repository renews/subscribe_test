# Sales Taxes

Solution to the sales taxes problem: reads a shopping basket and prints the
receipt with the price of each item (tax included), the total sales taxes and
the total cost.

## Problem

This problem requires some kind of input. You are free to implement any
mechanism for feeding the input into your solution. You should provide
sufficient evidence that your solution is complete by, as a minimum, indicating
that it works correctly against the supplied test data.

Basic sales tax is applicable at a rate of 10% on all goods, except books,
food, and medical products that are exempt. Import duty is an additional sales
tax applicable on all imported goods at a rate of 5%, with no exemptions.

When I purchase items I receive a receipt which lists the name of all the items
and their price (including tax), finishing with the total cost of the items,
and the total amounts of sales taxes paid. The rounding rules for sales tax are
that for a tax rate of n%, a shelf price of p contains (np/100 rounded up to
the nearest 0.05) amount of sales tax.

Write an application that prints out the receipt details for these shopping
baskets:

### Input

```text
Input 1:
2 book at 12.49
1 music CD at 14.99
1 chocolate bar at 0.85

Input 2:
1 imported box of chocolates at 10.00
1 imported bottle of perfume at 47.50

Input 3:
1 imported bottle of perfume at 27.99
1 bottle of perfume at 18.99
1 packet of headache pills at 9.75
3 imported boxes of chocolates at 11.25
```

### Output

```text
Output 1:
2 book: 24.98
1 music CD: 16.49
1 chocolate bar: 0.85
Sales Taxes: 1.50
Total: 42.32

Output 2:
1 imported box of chocolates: 10.50
1 imported bottle of perfume: 54.65
Sales Taxes: 7.65
Total: 65.15

Output 3:
1 imported bottle of perfume: 32.19
1 bottle of perfume: 20.89
1 packet of headache pills: 9.75
3 imported boxes of chocolates: 35.55
Sales Taxes: 7.90
Total: 98.38
```

## Setup

Requires Ruby 4.0+ (I use [mise](https://mise.jdx.dev) to manage it).

```sh
mise install
bundle install
```

## Running

Each input file is one basket. The baskets from the problem statement are in
`data/`.

```sh
bin/sales_tax data/input1.txt
bin/sales_tax data/input1.txt data/input2.txt data/input3.txt
cat data/input3.txt | bin/sales_tax
```

```text
$ bin/sales_tax data/input3.txt
1 imported bottle of perfume: 32.19
1 bottle of perfume: 20.89
1 packet of headache pills: 9.75
3 imported boxes of chocolates: 35.55
Sales Taxes: 7.90
Total: 98.38
```

## Project structure

```text
bin/sales_tax                      executable
lib/sales_tax.rb                   entry point, loads everything
lib/sales_tax/cli.rb               reads files or STDIN and prints the receipts
lib/sales_tax/models/
  item.rb                          a basket line (quantity, name, price, imported, exempt)
  receipt.rb                       receipt lines, sales taxes and total
lib/sales_tax/services/
  parser.rb                        turns the input text into items
  classifier.rb                    detects imported and exempt products
  tax_calculator.rb                tax rates and rounding
lib/sales_tax/utils/
  money.rb                         rounding to 0.05 and price formatting
test/unit/                         one test file per class, same folders as lib/
test/integration/                  runs bin/sales_tax against data/
data/                              inputs and expected outputs from the problem
```

## Tests

```sh
bundle exec rake test
bundle exec ruby -Itest test/unit/services/parser_test.rb
```

`test/integration/supplied_baskets_test.rb` runs the program against the three
inputs in `data/` and compares the result with the expected outputs.
It also checks that `data/input_4.txt` is rejected on line 2 because `9,75`
uses a comma. Parser tests separately cover its valid uppercase product names
and the blank product name on line 4, which the whole file check never reaches.

## Thread safety

I made each `Item` copy and freeze its product name, and each `Receipt` copy
and freeze its list of items. This lets me edit the original name or list
without changing an existing receipt.

In the classifier and tax calculator I kept no changing state between calls.

Once a receipt is constructed from `Item` objects, multiple threads can read it
using the built-in calculator. Each call calculates its own result from the same
protected values.

The CLI is intended for one run at a time, concurrent callers must use separate
inputs.

## Assumptions

- Each line follows the format `<quantity> <name> at <price>`.
- Product names cannot be blank or contain only whitespace.
- Prices use a decimal point, with at most two decimal places.
- Books, food and medical products are identified by name (`book`,
  `chocolate`, `pill`). To support more products, add them to
  `Services::Classifier::EXEMPT_PRODUCT_PATTERN`.
- Tax is rounded per unit and then multiplied by the quantity, which is what
  the expected output for `3 imported boxes of chocolates` requires.
- Prices are handled with `BigDecimal` to avoid floating point errors.
- Invalid lines stop the program with an error message showing the line number.
