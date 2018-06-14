defmodule Account do
  @moduledoc """
  This module armazenate the account struct.
  """
  @enforce_keys [:name, :email, :currency]
  defstruct name: "", email: "", currency: "USD", amount: 0

  import Currency

  @doc """
  Create user accounts

  ## Examples
    Account.create_account("LUIZ CARLOS", "luiz@gmail.com", "BRL", 500)
  """
  def create_account(name, email, currency, amount \\ 0) do
    if check_currency(currency) do
      %Account{name: name, email: email, currency: currency, amount: Decimal.new(amount)}
    else
      {:error, "Invalid currency"}
    end
  end

  @doc """
  Get the account amount in float

  ## Examples
    account = Account.create_account("LUIZ CARLOS", "luiz@gmail.com", "BRL", 500)<br/>
    Account.get_amount(account)
  """
  def get_amount(account) do
    {account.currency, Decimal.round(account.amount, 2) |> Decimal.to_float()}
  end

  @doc """
  Check if the account has sufficient funds

  ## Examples
    account = Account.create_account("LUIZ CARLOS", "luiz@gmail.com", "BRL", 500)<br/>
    Account.has_amount(account, 100)
  """
  def has_amount(account, amount) do
    if Decimal.cmp(account.amount, amount) == :gt or Decimal.cmp(account.amount, amount) == :eq,
      do: true,
      else: false
  end
end
