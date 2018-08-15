defmodule FinancialSystemTest do
  use ExUnit.Case
  doctest FinancialSystem

  setup_all do
    {
      :ok,
      [
        account1: Account.create("LUIZ CARLOS", "luiz@gmail.com", "BRL", 500),
        account2: Account.create("JOÃO PEDRO", "joao@gmail.com", "BRL", 500),
        account3: Account.create("CECILIA MARIA", "cecilia@gmail.com", "USD", 250),
        account4: Account.create("JULIANA MATOS", "juliana@gmail.com", "EUR", 100),
        account5: Account.create("LUCAS TAMARINO", "lucas@gmail.com", "GBP")
      ]
    }
  end

  test "User should be able to deposit money into the account", %{account1: account} do
    # Deposit in the same currency
    assert FinancialSystem.deposit(account, "BRL", 100)
  end

  test "User should be able to deposit foreign money into the account", %{account1: account} do
    # Deposit in different currency
    assert FinancialSystem.deposit(account, "USD", 100)
  end

  test "User should be able to debit money of the account", %{account2: account} do
    # Debit in same currency
    assert FinancialSystem.debit(account, "BRL", 20)
  end

  test "User should be able to debit foreign money of the account", %{account2: account} do
    # Debit in different currency
    assert FinancialSystem.debit(account, "USD", 20)
  end

  test "User should be able to transfer money to another account", %{
    account1: account1,
    account2: account2
  } do
    # Transfer in same currencies
    assert FinancialSystem.transfer(account1, account2, 50)
  end

  test "User should be able to transfer dollars to another account with different currency", %{
    account3: account3,
    account4: account4
  } do
    # Transfer in dollars to another currencies
    assert FinancialSystem.transfer(account3, account4, 50)
  end

  test "User should be able to transfer money to another account with different currency", %{
    account4: account4,
    account5: account5
  } do
    # Transfer in different currencies
    assert FinancialSystem.transfer(account4, account5, 5)
  end

  test "User cannot transfer if not enough money available on the account", %{
    account5: account5,
    account2: account2
  } do
    # Transfer with insufficient amount
    assert_raise RuntimeError, fn -> FinancialSystem.transfer(account5, account2, 2000) end
  end

  test "A transfer should be cancelled if an error occurs", %{account1: account1} do
    # Transfer with invalid account
    assert_raise FunctionClauseError, fn -> FinancialSystem.transfer(account1, nil, 50) end
  end

  test "A transfer can be splitted between 2 or more accounts", %{
    account3: account3,
    account4: account4,
    account5: account5
  } do
    list_accounts = [
      %{data: account4, percentage: 50},
      %{data: account5, percentage: 50}
    ]

    # Split between 2 accounts
    assert FinancialSystem.split(account3, list_accounts, 100)
  end

  test "A split should be cancelled if wrong percentage was passed", %{
    account3: account3,
    account4: account4,
    account5: account5
  } do
    list_accounts = [
      %{data: account4, percentage: 40},
      %{data: account5, percentage: 40}
    ]

    # Split with wrong percentage
    assert_raise ArgumentError, fn -> FinancialSystem.split(account3, list_accounts, 100) end
  end

  test "User should be able to exchange money between different currencies" do
    # Exchange currency
    assert FinancialSystem.exchange("BRL", "EUR", 100)
  end
end
