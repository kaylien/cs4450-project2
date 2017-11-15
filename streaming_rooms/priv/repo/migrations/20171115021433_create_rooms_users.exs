defmodule StreamingRooms.Repo.Migrations.CreateRoomsUsers do
  use Ecto.Migration

  def change do
    create table(:rooms_users) do
      add :num_youtube_streams, :integer
      add :num_spotify_streams, :integer
      add :in_room, :boolean, default: false, null: false
      add :joined, :boolean, default: false, null: false
      add :room_id, references(:rooms, on_delete: :nothing)
      add :user_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:rooms_users, [:room_id])
    create index(:rooms_users, [:user_id])
  end
end
