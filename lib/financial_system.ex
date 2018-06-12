defmodule FinancialSystem do
  @moduledoc """
  Financial system methods:
    create_account() - Create user accounts
    deposit() - Deposit into the account
    debit() - Debit the account
    transfer() - Transfer between accounts
    split() - Split transfer
    exchange() - Currency exchange
  """
  import Account
  import Money

  def create_account(name, email, currency) do
    if check_currency(currency), do: %Account{name: name, email: email, currency: currency}, else: raise ArgumentError, message: "Invalid currency"
  end

  def deposit(account, currency, amount) do
    currency = String.upcase(currency, :default)
    if check_currency(currency) do

      if account.currency == currency do
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

  # TODO: Should calculate IOF when necessary
  def exchange(from_currency, to_currency, amount) do
    from_rate_key = "USD#{String.upcase(from_currency, :default)}"
    to_rate_key = "USD#{String.upcase(to_currency, :default)}"

    rate = get_rate(from_currency, to_currency)["quotes"]
    diference = rate[from_rate_key] * rate[to_rate_key]
    diference * amount
  end

end
