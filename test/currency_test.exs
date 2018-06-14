defmodule CurrencyTest do
  use ExUnit.Case
  doctest Currency

  test "Check if the currency list is being retrieved" do
    # Get the currency list from the server
    assert Currency.get_currencies()
  end

  test "Check if the currency list from the json is being retrieved" do
    # Get the currency list from json file
    assert Currency.get_json("currency_list.json")
  end

  test "Check if the currency rates from the json is being retrieved" do
    # Get the currency rates from json file
    assert Currency.get_json("currency_rates.json")
  end

  test "Check the currencies rate in relation to USD" do
    # Get the currency rates list from server
    assert Currency.get_rate("BRL", "EUR")
  end

  test "Currencies should be in compliance with ISO 4217" do
    # Check if invalid currency
    assert Currency.check_currency("ERROR") == false
  end
end
