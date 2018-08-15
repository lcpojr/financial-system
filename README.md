# Financial System [![Build Status](https://semaphoreci.com/api/v1/lcpojr/financial-system/branches/formatter/badge.svg)](https://semaphoreci.com/lcpojr/financial-system) [![Coverage Status](https://coveralls.io/repos/github/lcpojr/financial-system/badge.svg?branch=master)](https://coveralls.io/github/lcpojr/financial-system?branch=master)

Elixir project for the [Stone Tech Challenge](https://github.com/stone-payments/tech-challenge)

## About

The idea of this project is create a set of tools capable of dealing with monetary operations like deposits, debits, transfer between accounts and exchange.  

* The currencies operated on the system should be in compliance with [ISO 4217](https://pt.wikipedia.org/wiki/ISO_4217).
* Currencies and rates are picked up from https://currencylayer.com/ just to keep the system updated as much as possible.
* In case of not being able to obtain the data, the system will use the Json files in the project.
* The rates and currencies in the json files were extracted from https://currencylayer.com/ on 6/12/2018.

## Requeriments / Dependencies

- [Elixir](https://github.com/elixir-lang/elixir) (v1.6.5)
- [HTTPotion](https://github.com/myfreeweb/httpotion) (To make the HTTP requests)
- [Poison](https://github.com/devinus/poison) (To parse the HTTP Json response)
- [Decimal](https://github.com/ericmj/decimal) (To arbitrary precision arithmetic)

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

# Get account amount
Account.get_amount(account1)

# Debit from accounts
account2 = FinancialSystem.debit(account2, "BRL", 100) # Debit in the same currency
account3 = FinancialSystem.debit(account3, "BRL", 100) # Debit with exchange

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
`MIX_ENV=test mix coveralls` to run coverage test.

## Formatation

To auto format the code and be sure that it's in compliance with the language style guide use `mix format`.

## Documentation

To generate a documentation by the code uses `mix docs`.
It will create a doc folder in the project with the HTML pages.

## Quality control

To ensure the quality of the code some tools were used:

* [ExCoveralls](https://coveralls.io/github/lcpojr/financial-system) for couverage test.
* [Semaphore](https://semaphoreci.com/lcpojr/financial-system) for continuous integration.
