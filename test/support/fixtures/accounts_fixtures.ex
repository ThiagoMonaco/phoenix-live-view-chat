defmodule Chat.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Chat.Accounts` context.
  """

  @doc """
  Generate a account.
  """
  def account_fixture(attrs \\ %{}) do
    {:ok, account} =
      attrs
      |> Enum.into(%{
        email: "some email",
        name: "some name",
        password: "some password"
      })
      |> Chat.Accounts.create_account()

    account
  end
end
