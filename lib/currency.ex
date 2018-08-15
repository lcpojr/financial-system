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

  @doc """
  Check if a currency is in compliance with ISO 4217.

  ## Examples
    Currency.is_valid?("BRL")
  """
  @spec is_valid?(String.t()) :: boolean()
  def is_valid?(currency) when byte_size(currency) > 0 do
    currency_list() |> Map.has_key?(currency)
  end

  @doc """
  Get the currencys list in compliance with ISO 4217.
  This method will looking for it in the list on server or/and in the json file.

  ## Examples
    Currency.currency_list()
  """
  @spec currency_list() :: map() | RuntimeError
  def currency_list() do
    Agent.start_link(fn -> %{} end, name: __MODULE__)

    cond do
      currency_list!(:request) != {:error} -> Agent.get(__MODULE__, fn map -> map end)
      currency_list!(:json) != {:error} -> Agent.get(__MODULE__, fn map -> map end)
      true -> raise "Unable to get list from server and json file"
    end
  end

  @spec currency_list!(atom()) :: map() | {:error}
  defp currency_list!(:request) do
    # Requesting currency list from server
    response = HTTPotion.get("http://apilayer.net/api/list?%20access_key=#{@api_key}")

    if HTTPotion.Response.success?(response) do
      Agent.update(__MODULE__, fn %{} -> Poison.decode!(response.body)["currencies"] end)
    else
      {:error}
    end
  end

  @spec currency_list!(atom()) :: map() | {:error}
  defp currency_list!(:json) do
    # Getting currency list from file
    case File.read("currency_list.json") do
      {:ok, body} ->
        Agent.update(__MODULE__, fn %{} -> Poison.decode!(body)["currencies"] end)

      true ->
        {:error}
    end
  end

  @doc """
  Get the currencys rates.
  This method will looking for the rates on server or/and in the json file.

  ## Examples
    Currency.currency_rate()
  """
  @spec currency_rate() :: map() | RuntimeError
  def currency_rate() do
    Agent.start_link(fn -> %{} end, name: __MODULE__)

    cond do
      currency_rate!(:request) != {:error} ->
        Agent.get(__MODULE__, fn map -> map end)

      currency_rate!(:json) != {:error} ->
        Agent.get(__MODULE__, fn map -> map end)

      true ->
        raise "Unable to get the rate from server and json file"
    end
  end

  @spec currency_rate!(:request) :: map() | {:error}
  defp currency_rate!(:request) do
    # Requesting currency rates from server
    response = HTTPotion.get("http://apilayer.net/api/live?access_key=#{@api_key}&format=1")

    if HTTPotion.Response.success?(response) do
      Agent.update(__MODULE__, fn %{} -> Poison.decode!(response.body)["quotes"] end)
    else
      {:error}
    end
  end

  @spec currency_rate!(:json) :: map() | {:error}
  defp currency_rate!(:json) do
    # Getting currency list from server
    case File.read("currency_rates.json") do
      {:ok, body} -> Agent.update(__MODULE__, fn %{} -> Poison.decode!(body)["quotes"] end)
      true -> {:error}
    end
  end
end
