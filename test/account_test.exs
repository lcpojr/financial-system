defmodule AccountTest do
  use ExUnit.Case
  doctest Account

  test "User should be able to create a account" do
    assert Account.create_account("LUIZ CARLOS", "luiz@gmail.com", "BRL")
  end
  
end
