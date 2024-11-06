defmodule Waldo.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table(:images) do
      add :data, :binary, null: false
      add :label, :string
      add :objects, {:array, :string}

      timestamps(type: :utc_datetime)
    end
  end
end
