defmodule Account do
  @moduledoc """
  This module armazenate the account struct.
  """
  @enforce_keys [:name, :email, :currency]
  defstruct name: "", email: "", currency: "", amount: 0
end
