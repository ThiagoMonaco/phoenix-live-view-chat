defmodule Chat.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "account" do
    field :name, :string
    field :password, :string
    field :email, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name, :email, :password])
    |> validate_required([:name, :email, :password])
    |> validate_length(:name, min: 3, max: 20)
    |> validate_length(:email, max: 52)
    |> validate_format(:password, ~r/[0-9]+/, message: "Password must contain a number") 
    |> validate_format(:password, ~r/[A-Z]+/, message: "Password must contain an upper-case letter")
    |> validate_format(:password, ~r/[a-z]+/, message: "Password must contain a lower-case letter")
    |> unique_constraint(:email, name: :account_email_index)
    |> unique_constraint(:name, name: :account_name_index)
    |> validate_format(:password, ~r/[#\!\?&@\$%^&*\(\)]+/, message: "Password must contain a symbol")
  end
end
