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
  
end
