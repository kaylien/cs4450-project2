defmodule StreamingRooms.Repo.Migrations.CreateRooms do
  use Ecto.Migration

  def change do
    create table(:rooms) do
      add :name, :string
      add :spotify_link, :string
      add :youtube_link, :string
      add :admin_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:rooms, [:admin_id])
  end
end
