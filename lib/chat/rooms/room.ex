defmodule Chat.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "rooms" do
    field :name, :string
    field :slug, :string
    field :owner_id, :binary_id

    timestamps(type: :utc_datetime)
  end

  def changeset(room, attrs) do
    room
      |> cast(attrs, [:name, :slug, :owner_id])
      |> validate_required([:name, :slug, :owner_id])
      |> validate_length(:name, max: 30)
      |> unique_constraint(:slug)
      |> unique_constraint(:name)
  end

end
