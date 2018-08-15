defmodule CurrencyTest do
  use ExUnit.Case
  doctest Currency

  test "Currencies should be in compliance with ISO 4217" do
    # Check if invalid currency
    assert Currency.is_valid?("USD") == true
    assert Currency.is_valid?("TAS") == false
  end

  test "The currencies list should be getted from server or json file automatically" do
    # Get the currency list from the server or json file automatically
    assert Currency.currency_list()
  end

  test "The currencies rates should be getted from server or json file automatically" do
    # Get the currency rates from server or json file automatically
    Agent.start_link(fn -> %{} end, name: Currency)
    assert Currency.currency_rate()
  end
end
