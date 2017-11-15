defmodule StreamingRooms.Repo.Migrations.NumStreamsToBigInts do
  use Ecto.Migration

  def change do
	alter table(:rooms_users) do
	  remove :num_youtube_streams
	  add :num_youtube_streams, :bigint
	  remove :num_spotify_streams
	  add :num_spotify_streams, :bigint
	end
  end

end
