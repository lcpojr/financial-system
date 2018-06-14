defmodule CurrencyTest do
  use ExUnit.Case
  doctest Currency

  test "Check if the currency list is being retrieved" do
    assert Currency.get_currencies()
  end

  test "Check if the currency list from the json is being retrieved" do
    assert Currency.get_json("currency_list.json")
  end

  test "Check if the currency rates from the json is being retrieved" do
    assert Currency.get_json("currency_rates.json")
  end

  test "Check the currencies rate in relation to USD" do
    assert Currency.get_rate("BRL", "EUR")
  end

  test "Currencies should be in compliance with ISO 4217" do
    assert Currency.check_currency("GBP")
  end

end
