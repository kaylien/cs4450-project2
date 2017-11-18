defmodule StreamingRooms.Repo.Migrations.CreateIndexRoomUsers do
  use Ecto.Migration

  def change do
	create unique_index(:rooms_users, [:user_id, :room_id], name: :room_user_index)
  end
end
