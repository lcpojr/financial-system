defmodule AccountTest do
  use ExUnit.Case
  doctest Account

  setup_all do
    {:ok, [account1: Account.create_account("LUIZ CARLOS", "luiz@gmail.com", "BRL", 500)]}
  end

  test "User should be able to create a account" do
    assert Account.create_account("JORGE AMANTO", "jorge@gmail.com", "JMD") # Create a user account
  end

  test "User should be able to get the account amount", %{account1: account} do
    assert Account.get_amount(account) # Get the account amount in float
  end

  test "User should be able to check if account has enough money", %{account1: account} do
    assert Account.has_amount(account, 50) # Check if the account has sufficient amount
  end

end
