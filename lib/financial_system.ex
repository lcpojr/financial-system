defmodule FinancialSystem do
  @moduledoc """
  The base module of the system.
  It contains functions to create accounts and transactions.
  """

  import Currency

  @doc "Deposit into the account"
  def deposit(account, currency, amount) do
    currency = String.upcase(currency, :default)
    if check_currency(currency) do

      if account.currency == currency do
        # Default
        %{account | amount: account.amount + amount}
      else
        # Exchange
        value_exchange = exchange(currency, account.currency, amount)
        %{account | amount: account.amount + value_exchange}
      end

    else
      raise ArgumentError, message: "Invalid currency"
    end
  end

  @doc "Debit the account"
  def debit(account, currency, amount) do
    currency = String.upcase(currency, :default)
    if check_currency(currency) do

      if account.amount >= amount do
        if account.currency == currency do
          # Default
          %{account | amount: account.amount - amount}
        else
          # Exchange
          value_exchange = exchange(account.currency, currency, amount)
          %{account | amount: account.amount - value_exchange}
        end
      else
        raise ArgumentError, message: "Insufficient funds"
      end

    else
      raise ArgumentError, message: "Invalid currency"
    end
  end

  @doc "Transfer between accounts"
  def transfer(from_account, to_account, amount) do
    if from_account.amount >= amount do

      if from_account.currency == to_account.currency do
        # Default
        from_account = %{from_account | amount: from_account.amount - amount}
        to_account = %{to_account | amount: to_account.amount + amount}
        {from_account, to_account}
      else
        # Exchange
        value_exchange = exchange(from_account.currency, to_account.currency, amount)

        from_account = %{from_account | amount: from_account.amount - amount}
        to_account = %{to_account | amount: to_account.amount + value_exchange}
        {from_account, to_account}
      end

    else
      raise ArgumentError, message: "Insufficient funds"
    end
  end

  @doc "Split transfer between two or more accounts"
  def split(from_account, list_accounts, amount) do
    if from_account.amount >= amount do
      Enum.map_every(list_accounts, 1, fn(to_account) ->
        if from_account.currency == to_account.data.currency do
          # Default
          %{to_account.data | amount: to_account.data.amount + (amount * to_account.percentage / 100)}
        else
          # Exchange
          value_exchange = exchange(from_account.currency, to_account.data.currency, (amount * to_account.percentage / 100))
          %{to_account.data | amount: to_account.data.amount + value_exchange}
        end
      end)
    else
      raise ArgumentError, message: "Insufficient funds"
    end
  end

  @doc "Currency exchange"
  # TODO: Should calculate IOF when necessary in the future
  def exchange(from_currency, to_currency, amount) do
    from_rate_key = "USD#{String.upcase(from_currency, :default)}"
    to_rate_key = "USD#{String.upcase(to_currency, :default)}"

    rate = get_rate(from_currency, to_currency)["quotes"] # Get the currency rate
    diference = rate[from_rate_key] * rate[to_rate_key] # Calculating the diference
    diference * amount # Calculating the exchange
  end

end
