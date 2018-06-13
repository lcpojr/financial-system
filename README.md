# Financial System

Elixir project for the [Stone Tech Challenge](https://github.com/stone-payments/tech-challenge)

## About

The idea of this project is create a set of tools capable of dealing with monetary operations like deposits, debits, transfer between accounts and exchange.  
The currencys operated on the system should be in compliance with [ISO 4217](https://pt.wikipedia.org/wiki/ISO_4217).

## Requeriments / Dependencies

- **[Elixir]**(https://github.com/elixir-lang/elixir)
- **[HTTPotion]**(https://github.com/myfreeweb/httpotion)
- **[Poison]**(https://github.com/devinus/poison)
- **[Decimal]**(https://github.com/ericmj/decimal)

## Installation

Elixir (Ubuntu v14.04+ or Debian v7+).  
To another distributions follow the steps in this page: https://elixir-lang.org/install.html

```
wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && sudo dpkg -i erlang-solutions_1.0_all.deb
sudo apt-get update
sudo apt-get install esl-erlang
sudo apt-get install elixir
```

After the installation finish you should clone this project and install the dependencies.

```
mix deps.get
```

## Usage

To run Elixir interactive shell use `iex -S mix`

```
# Creating user accounts
account1 = Account.create_account("LUIZ CARLOS", "luiz@gmail.com", "BRL", 1000)
account2 = Account.create_account("JOÃO PEDRO", "joao@gmail.com", "BRL")
account3 = Account.create_account("CECILIA MARIA", "cecilia@gmail.com", "USD")

# Deposit into accounts
account2 = FinancialSystem.deposit(account2, "BRL", 200) # Deposit in the same currency
account3 = FinancialSystem.deposit(account3, "BRL", 500) # Deposit with exchange

# Debit from accounts
account2 = FinancialSystem.deposit(account2, "BRL", 100) # Debit in the same currency
account3 = FinancialSystem.deposit(account3, "BRL", 100) # Debit with exchange

# Transfer between accounts
{account1, account2} = FinancialSystem.transfer(account1, account2, 50) # Transfer in the same currency
{account1, account3} = FinancialSystem.transfer(account1, account3, 50) # Transfer with exchange

# Split transfer
list_accounts = [
  %{ data: account2, percentage: 50}, # Split in the same currency
  %{ data: account3, percentage: 50}  # Split with exchange
]
{account1, list_accounts} = FinancialSystem.split(account1, list_accounts, 100)
```

### Testing

`mix test` to run unit tests.
