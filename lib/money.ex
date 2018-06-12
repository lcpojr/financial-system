defmodule Money do
  @moduledoc """
  Money methods:
    get_currencys() - Get a list of currencys in compliance with ISO 4217
    check_currency() - Check if a currency is on the list
  """
  @api_key "dfbc0e88687fcbe50c40eedccc30039d"

  def get_currencys() do
    response = HTTPotion.get("http://apilayer.net/api/list?%20access_key=#{@api_key}")
    if response.status_code == 200, do: Poison.decode!(response.body), else: raise "HTTP error - #{response.body}"
  end

  def check_currency(currency) do
    currency = String.upcase(currency, :default)
    if Map.has_key?(get_currencys()["currencies"], String.upcase(currency, :default)), do: true, else: false
  end

end
