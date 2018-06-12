defmodule Currency do
  @moduledoc """
  This module contains the currency verifications.
  The rates are requested from https://currencylayer.com/ with a free api for test purposes.
  You can change the api for one of your confidence just setting the URL and the FinancialSystem.exchange().
  It uses  httpotion to make the requests and poison to parse the json response.
    - https://github.com/myfreeweb/httpotion
    - https://github.com/devinus/poison
  """

  @api_key "dfbc0e88687fcbe50c40eedccc30039d"

  @doc "Get a list of currencys in compliance with ISO 4217"
  def get_currencys() do
    response = HTTPotion.get("http://apilayer.net/api/list?%20access_key=#{@api_key}")
    if HTTPotion.Response.success?(response), do: Poison.decode!(response.body), else: get_json("currency_list.json")
  end

  @doc "Get the currency data from json file in case of unable to get in the server"
  def get_json(file_name) do
    case File.read(file_name) do
      {:ok, body} -> Poison.decode!(body)
      {:error, reason} -> raise "Unable to get the data from server and file: #{reason}"
    end
  end

  @doc "Get the currency rate in relation to USD"
  def get_rate(from_currency, to_currency) do
    from_currency = String.upcase(from_currency, :default)
    to_currency = String.upcase(to_currency, :default)
    response = HTTPotion.get("http://apilayer.net/api/live?access_key=#{@api_key}&currencies=#{from_currency},#{to_currency}&format=1")
    if response.status_code == 200, do: Poison.decode!(response.body), else: get_json("currency_rates.json")
  end

  @doc "Check if a currency is on the list"
  def check_currency(currency) do
    currency = String.upcase(currency, :default)
    if Map.has_key?(get_currencys()["currencies"], String.upcase(currency, :default)), do: true, else: false
  end

end
