defmodule Chat.Repo.Migrations.AddTableRooms do
  use Ecto.Migration

  def change do
    create table(:rooms, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :slug, :string
      add :owner_id, references(:users, on_delete: :delete_all, type: :binary_id) 

      timestamps()
    end

    create unique_index(:rooms, [:slug])
    create unique_index(:rooms, [:name])
  end
end


