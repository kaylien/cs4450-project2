defmodule StreamingRooms.Repo.Migrations.RoomsUsersChangeFromSpotifyToSoundcloud do
  use Ecto.Migration

  def change do
	alter table(:rooms_users) do
	  remove :num_spotify_streams
	  add :num_soundcloud_streams, :bigint
	end
  end

end
