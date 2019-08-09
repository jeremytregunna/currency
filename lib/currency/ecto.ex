defmodule Currency.Ecto do
  @moduledoc """
  Provides a custom type for use in an Ecto schema to use Currency as a field
  type.

  ## Usage:

  Schema:

      defmodule Thing do
        use Ecto.Schema

        schema "things" do
          field :name, :string
          field :cost, Currency.Ecto
        end
      end

  Migration:

      def change do
        execute "CREATE TYPE currency AS (
            units integer,
            precision integer,
            currency varchar
          );
        "

        create table(:things) do
          add :name, :string
          add :cost, :currency
        end
      end
  """

  @behaviour Ecto.Type

  def type, do: :currency

  # TODO: Implement
  def cast(_), do: :error

  def load({units, precision, currency})
      when is_integer(units) and is_integer(precision) and is_binary(currency) do
    {:ok, %Currency{units: units, precision: precision, currency: currency}}
  end

  def load(_) do
    :error
  end

  def dump(%Currency{units: units, precision: precision, currency: currency}) do
    {:ok, {units, precision, currency}}
  end

  def dump(_) do
    :error
  end
end
