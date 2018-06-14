defmodule AccountTest do
  use ExUnit.Case
  doctest Account

  test "User should be able to create a account" do
    assert Account.create_account("LUIZ CARLOS", "luiz@gmail.com", "BRL")
  end

  test "User should be able to get the account amount" do
    account = Account.create_account("LUIZ CARLOS", "luiz@gmail.com", "BRL", 50)
    assert Account.get_amount(account)
  end

  test "User should be able to check if account has enough money" do
    account = Account.create_account("LUIZ CARLOS", "luiz@gmail.com", "BRL", 100)
    assert Account.has_amount(account, 50)
  end


end
