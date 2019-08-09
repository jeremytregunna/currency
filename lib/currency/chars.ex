defimpl String.Chars, for: Currency do
  defdelegate to_string(data), to: Currency
end
