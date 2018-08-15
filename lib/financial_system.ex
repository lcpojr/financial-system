defmodule FinancialSystem do
  @moduledoc """
  The base module of the system.
  It contains functions to create accounts and transactions.
  """

  @doc """
  Deposit into the account

  ## Examples
    account = Account.create("LUIZ CARLOS", "luiz@gmail.com", "BRL")<br/>
    account = FinancialSystem.deposit(account, "BRL", 100)
  """
  @spec deposit(Account.t(), String.t(), number()) :: Account.t()
  def deposit(%Account{} = account, currency, amount)
      when byte_size(currency) > 0 and is_number(amount) do
    currency = String.upcase(currency)

    if Currency.is_valid?(currency) do
      deposit!(account, account.currency == currency, currency, amount)
    else
      raise(ArgumentError, message: "invalid currency")
    end
  end

  @spec deposit!(Account.t(), true, String.t(), number()) :: Account.t()
  defp deposit!(account, _same_currency = true, _currency, amount) do
    # Deposit in the same Currency
    %{account | amount: Decimal.add(account.amount, amount) |> Decimal.round(2)}
  end

  @spec deposit!(Account.t(), false, String.t(), number()) :: Account.t()
  defp deposit!(account, _same_currency = false, currency, amount) do
    # Deposit with exchange
    amount = exchange(account.currency, currency, amount)
    %{account | amount: Decimal.add(account.amount, amount) |> Decimal.round(2)}
  end

  @doc """
  Debit the account

  ## Examples
    account = Account.create("LUIZ CARLOS", "luiz@gmail.com", "BRL", 100)<br/>
    account = FinancialSystem.debit(account, "BRL", 20)
  """
  @spec debit(Account.t(), String.t(), number()) :: Account.t()
  def debit(%Account{} = account, currency, amount)
      when byte_size(currency) > 0 and is_number(amount) do
    currency = String.upcase(currency)

    if Currency.is_valid?(currency) do
      debit!(account, account.currency == currency, currency, amount)
    else
      raise(ArgumentError, message: "invalid currency")
    end
  end

  @spec debit!(Account.t(), true, String.t(), number()) :: Account.t()
  defp debit!(account, _same_currency = true, _currency, amount) do
    # Debit in the same currency
    %{account | amount: Decimal.sub(account.amount, amount) |> Decimal.round(2)}
  end

  @spec debit!(Account.t(), false, String.t(), number()) :: Account.t()
  defp debit!(account, _same_currency = false, currency, amount) do
    # Debit with exchange
    amount = exchange(account.currency, currency, amount)
    %{account | amount: Decimal.sub(account.amount, amount) |> Decimal.round(2)}
  end

  @doc """
  Transfer between accounts

  ## Examples
    account1 = Account.create("LUIZ CARLOS", "luiz@gmail.com", "BRL", 100)<br/>
    account2 = Account.create("JOÃO PEDRO", "joao@gmail.com", "BRL")<br/>
    {account1, account2} = FinancialSystem.transfer(account1, account2, 50)
  """
  @spec transfer(Account.t(), Account.t(), number()) :: {Account.t(), Account.t()}
  def transfer(%Account{} = from_account, %Account{} = to_account, amount)
      when is_number(amount) do
    if Account.has_funds?(from_account, amount) do
      from_account = debit(from_account, from_account.currency, amount)
      to_account = deposit(to_account, from_account.currency, amount)
      {from_account, to_account}
    else
      raise "insuficient funds"
    end
  end

  @doc """
  Split transfer between two or more accounts
  The summ of percentages should be equal to 100.

  ## Examples
    account1 = Account.create("LUIZ CARLOS", "luiz@gmail.com", "BRL", 200)<br/>
    account2 = Account.create("JOÃO PEDRO", "joao@gmail.com", "BRL")<br/>
    account3 = Account.create("CECILIA MARIA", "cecilia@gmail.com", "USD")<br/>
    list_accounts = [%{ data: account2, percentage: 50},%{ data: account3, percentage: 50}]<br/>
    {account1, list_accounts} = FinancialSystem.split(account1, list_accounts, 100)
  """
  @spec split(Account.t(), list(), number()) :: {Account.t(), [Account.t()]}
  def split(%Account{} = from_account, list_accounts, amount)
      when is_list(list_accounts) and is_number(amount) do
    cond do
      Account.has_funds?(from_account, amount) == false ->
        raise(ArgumentError, message: "insuficient funds")

      has_percentage?(list_accounts) == false ->
        raise(ArgumentError, message: "invalid percentage")

      true ->
        split!(from_account, list_accounts, amount)
    end
  end

  @spec split!(Account.t(), list(), number()) :: {Account.t(), [Account.t()]}
  defp split!(from_account, list_accounts, amount) do
    from_account = debit(from_account, from_account.currency, amount)

    list_accounts =
      Enum.map_every(list_accounts, 1, fn to_account ->
        # Calculating the new amounts by percentage
        value_percentage =
          amount
          |> Decimal.new()
          |> Decimal.mult(to_account.percentage)
          |> Decimal.div(100)
          |> Decimal.round(2)
          |> Decimal.to_float()

        deposit(to_account.data, from_account.currency, value_percentage)
      end)

    {from_account, list_accounts}
  end

  @doc """
  Check the split percentage for every account

  ## Examples
    account2 = Account.create("JOÃO PEDRO", "joao@gmail.com", "BRL")<br/>
    account3 = Account.create("CECILIA MARIA", "cecilia@gmail.com", "USD")<br/>
    FinancialSystem.has_percentage?([%{ data: account2, percentage: 50},%{ data: account3, percentage: 50}])
  """
  @spec has_percentage?(list()) :: boolean()
  def has_percentage?(list_accounts) do
    Enum.reduce(list_accounts, fn to_account, frist_account ->
      to_account.percentage + frist_account.percentage
    end) == 100
  end

  @doc """
  Exchange currency values based on dollar

  ## Examples
    FinancialSystem.exchange("BRL","USD", 100)
  """
  @spec exchange(String.t(), String.t(), number()) :: number()
  def exchange(from_currency, to_currency, amount)
      when byte_size(from_currency) > 0 and byte_size(to_currency) > 0 and is_number(amount) do
    cond do
      Currency.is_valid?(from_currency) == false ->
        raise(ArgumentError, message: "invalid from_currency")

      Currency.is_valid?(to_currency) == false ->
        raise(ArgumentError, message: "invalid to_currency")

      from_currency == to_currency ->
        amount

      true ->
        Currency.currency_rate() |> exchange!(from_currency, to_currency, amount)
    end
  end

  @spec exchange!(list(), String.t(), String.t(), number()) :: number()
  defp exchange!(rate_list, from_currency, _to_currency = "USD", amount) do
    # Exchange other currency to dollar
    amount
    |> Decimal.new()
    |> Decimal.mult(Decimal.new(rate_list["USD#{from_currency}"]))
    |> Decimal.round(2)
  end

  @spec exchange!(list(), String.t(), String.t(), number()) :: number()
  defp exchange!(rate_list, _from_currency = "USD", to_currency, amount) do
    # Exchange dollar to another currency
    amount
    |> Decimal.new()
    |> Decimal.div(Decimal.new(rate_list["USD#{to_currency}"]))
    |> Decimal.round(2)
  end

  @spec exchange!(list(), String.t(), String.t(), number()) :: number()
  defp exchange!(rate_list, from_currency, to_currency, amount) do
    # Exchange two different currencys that isn't dollar
    amount
    |> Decimal.new()
    |> Decimal.div(Decimal.new(rate_list["USD#{to_currency}"]))
    |> Decimal.mult(Decimal.new(rate_list["USD#{from_currency}"]))
    |> Decimal.round(2)
  end
end
