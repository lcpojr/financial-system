defmodule FinancialSystemTest do
  use ExUnit.Case
  doctest FinancialSystem

  test "User should be able to create a account" do
    assert FinancialSystem.create_account("LUIZ CARLOS", "luiz@gmail.com", "BRL") # Creating user account
  end

  test "User should be able to deposit money into the account" do
    account = FinancialSystem.create_account("LUIZ CARLOS", "luiz@gmail.com", "BRL")
    assert FinancialSystem.deposit(account, "BRL", 100) # Deposit in the same currency
  end

  test "User should be able to debit money of the account" do
    account = FinancialSystem.create_account("LUIZ CARLOS", "luiz@gmail.com", "BRL")
    account = FinancialSystem.deposit(account, "BRL", 500)
    assert FinancialSystem.debit(account, "BRL", 20) # Debit in same currency
  end

  test "User should be able to transfer money to another account" do
    account1 = FinancialSystem.create_account("LUIZ CARLOS", "luiz@gmail.com", "BRL")
    account2 = FinancialSystem.create_account("JOÃO PEDRO", "joao@gmail.com", "USD")
    account1 = FinancialSystem.deposit(account1, "BRL", 1000)
    assert FinancialSystem.transfer(account1, account2, 50) # Transfer in different currencys
  end

  test "User cannot transfer if not enough money available on the account" do
    account1 = FinancialSystem.create_account("LUIZ CARLOS", "luiz@gmail.com", "BRL")
    account2 = FinancialSystem.create_account("CECILIA MARIA", "cecilia@gmail.com", "BRL")
    account1 = FinancialSystem.deposit(account1, "BRL", 10)
    assert catch_error(FinancialSystem.transfer(account1, account2, 200)) # Transfer with insufficient amount
  end

  test "A transfer should be cancelled if an error occurs" do
    account1 = FinancialSystem.create_account("LUIZ CARLOS", "luiz@gmail.com", "BRL")
    account1 = FinancialSystem.deposit(account1, "BRL", 100)
    assert catch_error(FinancialSystem.transfer(account1, nil, 50)) # Transfer with invalid account
  end

  test "A transfer can be splitted between 2 or more accounts" do
    account1 = FinancialSystem.create_account("LUIZ CARLOS", "luiz@gmail.com", "BRL")
    account2 = FinancialSystem.create_account("JOÃO PEDRO", "joao@gmail.com", "USD")
    account3 = FinancialSystem.create_account("CECILIA MARIA", "cecilia@gmail.com", "BRL")
    account4 = FinancialSystem.create_account("JULIANA MATOS", "juliana@gmail.com", "EUR")
    account5 = FinancialSystem.create_account("LUCAS TAMARINO", "lucas@gmail.com", "GBP")
    account1 = FinancialSystem.deposit(account1, "BRL", 1000)

    list_accounts = [
      %{ data: account2, percentage: 25},
      %{ data: account3, percentage: 25},
      %{ data: account4, percentage: 25},
      %{ data: account5, percentage: 25}
    ]

    assert FinancialSystem.split(account1, list_accounts, 1000)
  end

  test "User should be able to exchange money between different currencies" do
    assert FinancialSystem.exchange("BRL", "EUR", 100)
  end

  test "Currencies should be in compliance with ISO 4217" do
    assert Money.check_currency("GBP")
  end

end
