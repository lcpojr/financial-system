defmodule FinancialSystemTest do
  use ExUnit.Case
  doctest FinancialSystem

  setup_all do
    {
      :ok,
      [
        account1: Account.create_account("LUIZ CARLOS", "luiz@gmail.com", "BRL", 500),
        account2: Account.create_account("JOÃO PEDRO", "joao@gmail.com", "BRL", 500),
        account3: Account.create_account("CECILIA MARIA", "cecilia@gmail.com", "USD", 250),
        account4: Account.create_account("JULIANA MATOS", "juliana@gmail.com", "EUR", 100),
        account5: Account.create_account("LUCAS TAMARINO", "lucas@gmail.com", "GBP")
      ]
    }
  end

  test "User should be able to deposit money into the account", %{account1: account} do
    assert FinancialSystem.deposit(account, "BRL", 100) # Deposit in the same currency
  end

  test "User should be able to deposit foreign money into the account", %{account1: account} do
    assert FinancialSystem.deposit(account, "USD", 100) # Deposit in different currency
  end

  test "User should be able to debit money of the account", %{account2: account} do
    assert FinancialSystem.debit(account, "BRL", 20) # Debit in same currency
  end

  test "User should be able to debit foreign money of the account", %{account2: account} do
    assert FinancialSystem.debit(account, "USD", 20) # Debit in different currency
  end

  test "User should be able to transfer money to another account", %{account1: account1, account2: account2} do
    assert FinancialSystem.transfer(account1, account2, 50) # Transfer in same currencies
  end

  test "User should be able to transfer dollars to another account with different currency", %{account3: account3, account4: account4} do
    assert FinancialSystem.transfer(account3, account4, 50) # Transfer in dollars to another currencies
  end

  test "User should be able to transfer money to another account with different currency", %{account4: account4, account5: account5} do
    assert FinancialSystem.transfer(account4, account5, 5) # Transfer in different currencies
  end

  test "User cannot transfer if not enough money available on the account", %{account5: account5, account2: account2} do
    assert FinancialSystem.transfer(account5, account2, 2000) == {:error, "Insufficient funds"} # Transfer with insufficient amount
  end

  test "A transfer should be cancelled if an error occurs", %{account1: account1} do
    assert_raise UndefinedFunctionError, fn-> FinancialSystem.transfer(account1, nil, 50) end # Transfer with invalid account
  end

  test "A transfer can be splitted between 2 or more accounts", %{account3: account3, account4: account4, account5: account5} do
    list_accounts = [
      %{ data: account4, percentage: 50},
      %{ data: account5, percentage: 50}
    ]

    assert FinancialSystem.split(account3, list_accounts, 100) # Split between 2 accounts
  end

  test "A split should be cancelled if wrong percentage was passed", %{account3: account3, account4: account4, account5: account5} do
    list_accounts = [
      %{ data: account4, percentage: 40},
      %{ data: account5, percentage: 40}
    ]

    assert FinancialSystem.split(account3, list_accounts, 100) == {:error, "Invalid percentage"} # Split with wrong percentage
  end

  test "User should be able to exchange money between different currencies" do
    assert FinancialSystem.exchange("BRL", "EUR", 100) # Exchange currency
  end

end
