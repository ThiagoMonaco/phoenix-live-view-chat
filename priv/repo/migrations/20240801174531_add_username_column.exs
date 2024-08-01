defmodule Chat.Repo.Migrations.AddUsernameColumn do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :name, :text
    end

    create unique_index(:users, [:name])
  end

end
