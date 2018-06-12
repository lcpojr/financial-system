defmodule Account do
  @moduledoc """
  This module armazenate the account struct.
  """
  @enforce_keys [:name, :email, :currency]
  defstruct name: nil, email: nil, currency: nil, amount: 0

  import Currency

  @doc "Create user accounts"
  def create_account(name, email, currency, amount \\ 0) do
    if check_currency(currency), do: %Account{name: name, email: email, currency: currency, amount: amount}, else: raise ArgumentError, message: "Invalid currency"
  end

end
