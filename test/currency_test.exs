defmodule CurrencyTest do
  use ExUnit.Case
  doctest Currency

  test "Check if the currency list is being retrieved" do
    assert Currency.get_currencies() # Get the currency list from the server
  end

  test "Check if the currency list from the json is being retrieved" do
    assert Currency.get_json("currency_list.json") # Get the currency list from json file
  end

  test "Check if the currency rates from the json is being retrieved" do
    assert Currency.get_json("currency_rates.json") # Get the currency rates from json file
  end

  test "Check the currencies rate in relation to USD" do
    assert Currency.get_rate("BRL", "EUR") # Get the currency rates list from server
  end

  test "Currencies should be in compliance with ISO 4217" do
    assert Currency.check_currency("ERROR") == false # Check if invalid currency
  end

end
