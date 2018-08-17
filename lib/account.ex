defmodule Account do
  @moduledoc """
  This module define the account struct and functions.
  """
  @enforce_keys [:name, :email, :currency]
  defstruct name: "", email: "", currency: "USD", amount: 0

  @typedoc """
    Abstract account struct type
  """
  @type t :: %Account{
          name: String.t(),
          email: String.t(),
          currency: String.t(),
          amount: Decimal.t()
        }

  @doc """
  Create user accounts

  ## Examples
    Account.create("LUIZ CARLOS", "luiz@gmail.com", "BRL", 500)
  """
  @spec create(String.t(), String.t(), String.t(), float()) :: t() | ArgumentError
  def create(name, email, currency, amount \\ 0) do
    with true <- byte_size(name) > 0,
         true <- byte_size(email) > 0,
         true <- Currency.is_valid?(currency),
         true <- is_number(amount) do
      %Account{
        name: name,
        email: email,
        currency: String.upcase(currency),
        amount: Decimal.new(amount)
      }
    else
      _error -> raise(ArgumentError, message: "invalid arguments")
    end
  end

  @doc """
  Get the account funds in float

  ## Examples
    account = Account.create("LUIZ CARLOS", "luiz@gmail.com", "BRL", 500)<br/>
    Account.balance(account)
  """
  @spec balance(t()) :: float()
  def balance(%Account{} = account) do
    Decimal.round(account.amount, 2) |> Decimal.to_float()
  end

  @doc """
  Check if the account has sufficient funds

  ## Examples
    account = Account.create("LUIZ CARLOS", "luiz@gmail.com", "BRL", 500)<br/>
    Account.has_funds?(account, 100)
  """
  @spec has_funds?(t(), float()) :: boolean()
  def has_funds?(%Account{} = account, amount) do
    Enum.member?([:eq, :gt], Decimal.cmp(account.amount, amount))
  end
end
