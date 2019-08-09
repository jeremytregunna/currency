defimpl Inspect, for: Currency do
  def inspect(currency, _opts), do: "~M\"#{currency}\""
end
