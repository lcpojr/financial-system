defmodule AccountTest do
  use ExUnit.Case
  doctest Account

  setup_all do
    {:ok, [account1: Account.create("LUIZ CARLOS", "luiz@gmail.com", "BRL", 500)]}
  end

  test "User should be able to create a account in any currency" do
    # Create a user account
    assert Account.create("FLAVIO CANELA", "flavio@gmail.com", "USD")
    assert Account.create("JORGE AMANTO", "jorge@gmail.com", "JMD")
  end

  test "User should be able to get the account amount", %{account1: account} do
    # Get the account amount in float
    assert Account.balance(account)
  end

  test "User should be able to check if account has enough money", %{account1: account} do
    # Check if the account has sufficient amount
    assert Account.has_funds?(account, 50) == true
    assert Account.has_funds?(account, 1000) == false
  end
end
