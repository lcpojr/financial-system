defmodule FinancialSystem do
  @moduledoc """
  The base module of the system.
  It contains functions to create accounts and transactions.
  """

  import Currency

  @doc """
  Deposit into the account

  ## Examples
    iex> account = Account.create_account("LUIZ CARLOS", "luiz@gmail.com", "BRL")
    iex> account = FinancialSystem.deposit(account, "BRL", 100)
    %Account{amount: 100, currency: "BRL", email: "luiz@gmail.com", name: "LUIZ CARLOS"}
  """
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

  @doc """
  Debit the account

  ## Examples
    iex> account = Account.create_account("LUIZ CARLOS", "luiz@gmail.com", "BRL", 100)
    iex> account = FinancialSystem.debit(account, "BRL", 20)
    %Account{amount: 80, currency: "BRL", email: "luiz@gmail.com", name: "LUIZ CARLOS"}
  """
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

  @doc """
  Transfer between accounts

  ## Examples
    iex> account1 = Account.create_account("LUIZ CARLOS", "luiz@gmail.com", "BRL", 100)
    iex> account2 = Account.create_account("JOÃO PEDRO", "joao@gmail.com", "BRL")
    iex> {account1, account2} = FinancialSystem.transfer(account1, account2, 50)
    {
      %Account{amount: 50, currency: "BRL", email: "luiz@gmail.com", name: "LUIZ CARLOS"},
      %Account{amount: 50, currency: "BRL", email: "joao@gmail.com", name: "JOÃO PEDRO"}
    }
  """
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

  @doc """
  Split transfer between two or more accounts

  ## Examples
    iex> account1 = Account.create_account("LUIZ CARLOS", "luiz@gmail.com", "BRL", 200)
    iex> account2 = Account.create_account("JOÃO PEDRO", "joao@gmail.com", "BRL")
    iex> account3 = Account.create_account("CECILIA MARIA", "cecilia@gmail.com", "USD")

    iex> list_accounts = [%{ data: account2, percentage: 50},%{ data: account3, percentage: 50}]

    iex> {account1, list_accounts} = FinancialSystem.split(account1, list_accounts, 100)
    {
      %Account{amount: 0, currency: "BRL", email: "luiz@gmail.com", name: "LUIZ CARLOS"},
      [
        %Account{amount: 50.0, currency: "BRL", email: "joao@gmail.com", name: "JOÃO PEDRO"},
        %Account{amount: 185.51515, currency: "USD", email: "cecilia@gmail.com", name: "CECILIA MARIA"}
      ]
    }
  """
  def split(from_account, list_accounts, amount) do
    if from_account.amount >= amount do

      list_accounts = Enum.map_every(list_accounts, 1, fn(to_account) ->
        if from_account.currency == to_account.data.currency do
          # Default
          %{to_account.data | amount: to_account.data.amount + (amount * to_account.percentage / 100)}
        else
          # Exchange
          value_exchange = exchange(from_account.currency, to_account.data.currency, (amount * to_account.percentage / 100))
          %{to_account.data | amount: to_account.data.amount + value_exchange}
        end
      end)

      {%{from_account | amount: from_account.amount - amount}, list_accounts}

    else
      raise ArgumentError, message: "Insufficient funds"
    end
  end

  @doc """
  Currency exchange

  ## Examples
    iex> FinancialSystem.exchange("BRL","USD", 100)
    26.91043212502802
  """
  def exchange(from_currency, to_currency, amount) do
    from_rate_key = "USD#{String.upcase(from_currency, :default)}"
    to_rate_key = "USD#{String.upcase(to_currency, :default)}"

    rate = get_rate(from_currency, to_currency)["quotes"] # Get the currency rate
    cond do
      from_currency == to_currency -> amount
      from_currency == "USD" -> amount * rate[to_rate_key]
      to_currency == "USD" -> amount / rate[from_rate_key]
      true -> (amount / rate[from_rate_key]) * rate[to_rate_key]
    end
  end

end
