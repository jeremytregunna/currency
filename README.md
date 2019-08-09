# Currency

Currency is a library useful for dealing with ISO 4217 currency symbols,
that respects and enforces correct precision use, and can also perform basic
mathematical operations between sets of Currency structs.

## Usage

This library is intended to be used with textual representation of a currency.
For instance, you create an instance of `Currency` using an amount, and the
currency symbol, i.e., `USD` for US Dollar. These symbols correspond to ISO
4217.

```elixir
iex> Currency.new("15.99 USD")
~M"15.99 USD"
```

To access the `~M` sigil, simply `import Currency` wherever you intend to use
it.

This library also supports negative values, rounding extra bits of precision,
and simple operations like addition and subtraction. Consider:

```elixir
iex> import Currency
# Adding two currencies of the same type
iex> ~M"1.99 USD" |> Currency.add(~M"2.29 USD")
~M"4.28 USD"
# Subtracting...
iex> ~M"1.01 CAD" |> Currency.subtract(~M"4.77 CAD")
~M"-3.76 CAD"
# Rounding...
iex> ~M"1.234 USD"
~M"1.23 USD"
iex> ~M"1.236 USD"
~M"1.24 USD"
```

## Installation

This package can be installed by adding `currency` to your list of dependencies
in `mix.exs`:

```elixir
def deps do
  [
    {:currency, "~> 1.0.0"}
  ]
end
```

Documentation can be found at [https://hexdocs.pm/currency](https://hexdocs.pm/currency).

