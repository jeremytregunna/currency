defmodule Currency do
  @moduledoc """
  `Currency` represents a monetary value, stored in its smallest unit possible
  in a given currency, i.e., cents.

  See `Currency.Ecto` for a custom type implementation that can be used in a
  schema.

  In order to use the `~M` sigil, import the module:

      import Currency

  ## Example

      iex> Currency.new("25.00 USD")
      ~M"25.00 USD"

      iex> ~M"25.00 USD".currency
      "USD"
      iex> ~M"25.01 USD".units
      #Decimal<2501>

      iex> Currency.add(~M"10 USD", ~M"20 USD")
      ~M"30.00 USD"

      iex> Kernel.to_string(~M"-10.50 USD")
      "-10.50 USD"

      iex> ~M"12.348 USD"
      ~M"12.35 USD"

      # For cases which have more than 2 decimal places of precision
      iex> ~M"1500.23 CLF"
      ~M"1500.2300 CLF"

      # For cases which have 0 decimals of precision
      iex> ~M"500.1 XOF"
      ~M"500 XOF"
  """

  defstruct units: 0, precision: 0, currency: nil

  def new(str) when is_binary(str) do
    case parse(str) do
      {:ok, currency} -> currency
      :error -> raise ArgumentError, "invalid string: #{inspect(str)}"
    end
  end

  def sigil_M(str, _opts), do: new(str)

  def add(
        %Currency{units: left_units, precision: p, currency: c},
        %Currency{units: right_units, precision: p, currency: c}
      ) do
    %Currency{units: Decimal.add(left_units, right_units), precision: p, currency: c}
  end

  def subtract(
        %Currency{units: left_units, precision: p, currency: c},
        %Currency{units: right_units, precision: p, currency: c}
      ) do
    %Currency{units: Decimal.sub(left_units, right_units), precision: p, currency: c}
  end

  def to_string(%Currency{units: units, precision: precision, currency: currency}) do
    multiplier = round(:math.pow(10, precision))

    {major, minor} =
      {Decimal.div_int(units, Decimal.new(multiplier)),
       Decimal.abs(Decimal.rem(units, multiplier))}

    case precision do
      0 -> "#{major} #{currency}"
      _ -> "#{major}.#{minor} #{currency}"
    end
  end

  def parse(str) when is_binary(str) do
    case Regex.run(~r/\A(-?)(\d+)(\.(\d+))?\ ([A-Z]+)\z/, str) do
      [_, sign, major_units, _, minor_units, currency] ->
        do_parse(sign, Decimal.new("#{major_units}.#{minor_units}"), currency)

      _ ->
        :error
    end
  end

  defp do_parse(sign, raw_units, currency) do
    sign = if(sign == "-", do: "-1", else: "1")
    precision = precision_for_currency(currency)
    multiplier = round(:math.pow(10, precision))

    units =
      raw_units
      |> Decimal.mult(multiplier)
      |> Decimal.round()
      |> Decimal.mult(sign)

    {:ok, %Currency{units: units, precision: precision, currency: currency}}
  end

  defp precision_for_currency(code) do
    :currency
    |> Application.app_dir("priv/codes-all_json.json")
    |> read_iso_4217()
    |> Enum.find(&(&1["AlphabeticCode"] == code))
    |> Map.get("MinorUnit")
    |> Integer.parse()
    |> elem(0)
  end

  defp read_iso_4217(path) do
    path
    |> File.read!()
    |> Jason.decode!()
    |> Stream.filter(&(&1["WithdrawalDate"] == nil))
    |> Stream.uniq_by(& &1["AlphabeticCode"])
  end

  def pad_or_round(minor_units, precision) do
    how_many = String.length(minor_units)

    IO.inspect {how_many, precision}
    if how_many > precision do
      minor_units
      |> Decimal.round(precision - how_many)
      |> Decimal.to_integer()
      |> Integer.to_string()
      |> String.slice(0..(precision - 1))
      |> Decimal.new()
    else
      pad_zeros(minor_units, precision)
    end
  end

  def pad_zeros(minor_units, precision) when is_binary(minor_units) do
    if String.length(minor_units) >= precision do
      minor_units
    else
      pad_zeros("#{minor_units}0", precision)
    end
  end
end
