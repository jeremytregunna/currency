defmodule CurrencyTest do
  use ExUnit.Case
  import Currency

  doctest Currency

  test "symbol has 2 decimal places of precision, none supplied" do
    assert Currency.new("1 USD").units == Decimal.new(100)
    assert Currency.new("1 USD").precision == 2
  end

  test "symbol has 2 decimal places of precision and 1 level of precision supplied" do
    assert Currency.new("1.1 USD").units == Decimal.new(110)
  end

  test "symbol has 2 decimal places of precision and 2 levels of precision supplied" do
    assert Currency.new("1.12 USD").units == Decimal.new(112)
  end

  test "symbol has 2 decimal places of precision but more precision supplied, rounded" do
    assert Currency.new("1.999 USD").units == Decimal.new(200)
  end

  test "symbol has 0 decimal places of precision" do
    assert Currency.new("1 XOF").units == Decimal.new(1)
  end

  test "symbol has 0 decimal places of precision but precision supplied" do
    assert Currency.new("1.1 XOF").units == Decimal.new(1)
  end

  test "symbol has 0 decimal places of precision but precision supplied, rounded" do
    assert Currency.new("1.9 XOF").units == Decimal.new(2)
  end

  test "symbol has 4 decimal places of precision, none supplied" do
    assert Currency.new("1 USD").units == Decimal.new(100)
    assert Currency.new("1 USD").precision == 2
  end

  test "symbol has 4 decimal places of precision and 1 level of precision supplied" do
    assert Currency.new("1.1 CLF").units == Decimal.new(11000)
  end

  test "symbol has 4 decimal places of precision and 4 levels of precision supplied" do
    assert Currency.new("1.1234 CLF").units == Decimal.new(11234)
  end

  test "symbol has 4 decimal places of precision but more precision supplied, rounded" do
    assert Currency.new("1.99999 CLF").units == Decimal.new(20000)
  end
end
