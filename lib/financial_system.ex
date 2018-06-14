defmodule FinancialSystem do
  @moduledoc """
  The base module of the system.
  It contains functions to create accounts and transactions.
  """

  import Account
  import Currency

  @doc """
  Deposit into the account

  ## Examples
    account = Account.create_account("LUIZ CARLOS", "luiz@gmail.com", "BRL")<br/>
    account = FinancialSystem.deposit(account, "BRL", 100)
  """
  def deposit(account, currency, amount) do
    currency = String.upcase(currency, :default)
    amount = Decimal.new(amount)

    if check_currency(currency) do
      amount =
        cond do
          # Exchange
          account.currency != currency ->
            exchange(account.currency, currency, amount)

          true ->
            amount
        end

      %{account | amount: Decimal.add(account.amount, amount) |> Decimal.round(2)}
    else
      {:error, "Invalid currency"}
    end
  end

  @doc """
  Debit the account

  ## Examples
    account = Account.create_account("LUIZ CARLOS", "luiz@gmail.com", "BRL", 100)<br/>
    account = FinancialSystem.debit(account, "BRL", 20)
  """
  def debit(account, currency, amount) do
    currency = String.upcase(currency, :default)
    amount = Decimal.new(amount)

    if check_currency(currency) do
      if has_amount(account, amount) do
        amount =
          cond do
            # Exchange
            account.currency != currency ->
              exchange(account.currency, currency, amount)

            true ->
              amount
          end

        %{account | amount: Decimal.sub(account.amount, amount) |> Decimal.round(2)}
      else
        {:error, "Insufficient funds"}
      end
    else
      {:error, "Invalid currency"}
    end
  end

  @doc """
  Transfer between accounts

  ## Examples
    account1 = Account.create_account("LUIZ CARLOS", "luiz@gmail.com", "BRL", 100)<br/>
    account2 = Account.create_account("JOÃO PEDRO", "joao@gmail.com", "BRL")<br/>
    {account1, account2} = FinancialSystem.transfer(account1, account2, 50)
  """
  def transfer(from_account, to_account, amount) do
    amount = Decimal.new(amount)

    if has_amount(from_account, amount) do
      from_account = debit(from_account, from_account.currency, amount)

      amount =
        cond do
          # Exchange
          from_account.currency != to_account.currency ->
            exchange(from_account.currency, to_account.currency, amount)

          true ->
            amount
        end

      to_account = deposit(to_account, to_account.currency, amount)

      {from_account, to_account}
    else
      {:error, "Insufficient funds"}
    end
  end

  @doc """
  Split transfer between two or more accounts

  ## Examples
    account1 = Account.create_account("LUIZ CARLOS", "luiz@gmail.com", "BRL", 200)<br/>
    account2 = Account.create_account("JOÃO PEDRO", "joao@gmail.com", "BRL")<br/>
    account3 = Account.create_account("CECILIA MARIA", "cecilia@gmail.com", "USD")<br/>
    list_accounts = [%{ data: account2, percentage: 50},%{ data: account3, percentage: 50}]<br/>
    {account1, list_accounts} = FinancialSystem.split(account1, list_accounts, 100)
  """
  def split(from_account, list_accounts, amount) do
    amount = Decimal.new(amount)

    if has_amount(from_account, amount) do
      sum_percent =
        Enum.reduce(list_accounts, fn to_account, frist_account ->
          to_account.percentage + frist_account.percentage
        end)

      if sum_percent == 100 do
        from_account = debit(from_account, from_account.currency, amount)

        list_accounts =
          Enum.map_every(list_accounts, 1, fn to_account ->
            # Calculating the new amounts by percentage
            value_percentage = Decimal.mult(amount, to_account.percentage) |> Decimal.div(100)
            deposit(to_account.data, from_account.currency, value_percentage)
          end)

        {from_account, list_accounts}
      else
        {:error, "Invalid percentage"}
      end
    else
      {:error, "Insufficient funds"}
    end
  end

  @doc """
  Currency exchange

  ## Examples
    FinancialSystem.exchange("BRL","USD", 100)
  """
  def exchange(from_currency, to_currency, amount) do
    if check_currency(from_currency) and check_currency(to_currency) do
      amount = Decimal.new(amount)
      from_currency = String.upcase(from_currency, :default)
      to_currency = String.upcase(to_currency, :default)

      # Get the currency rate
      rate_list = get_rate(from_currency, to_currency)["quotes"]

      # Get from_currency rate in decimal
      from_rate = Decimal.new(rate_list["USD#{from_currency}"])
      # Get to_currency rate in decimal
      to_rate = Decimal.new(rate_list["USD#{to_currency}"])

      cond do
        from_currency == to_currency ->
          # Same currency
          amount

        from_currency == "USD" ->
          # Dollar to another currency
          Decimal.div(amount, to_rate)
          |> Decimal.round(2)

        to_currency == "USD" ->
          # Some currency to dollar
          Decimal.mult(amount, from_rate)
          |> Decimal.round(2)

        true ->
          # Different currencies that isen't dollar
          Decimal.div(amount, to_rate)
          |> Decimal.mult(from_rate)
          |> Decimal.round(2)
      end
    else
      {:error, "Invalid currency"}
    end
  end
end
