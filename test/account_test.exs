defmodule AccountTest do
  use ExUnit.Case
  doctest Account

  setup_all do
    {:ok, [account1: Account.create_account("LUIZ CARLOS", "luiz@gmail.com", "BRL", 500)]}
  end

  test "User should be able to create a account" do
    # Create a user account
    assert Account.create_account("JORGE AMANTO", "jorge@gmail.com", "JMD")
  end

  test "User should be able to get the account amount", %{account1: account} do
    # Get the account amount in float
    assert Account.get_amount(account)
  end

  test "User should be able to check if account has enough money", %{account1: account} do
    # Check if the account has sufficient amount
    assert Account.has_amount(account, 50)
  end
end
