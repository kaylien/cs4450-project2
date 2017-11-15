defmodule StreamingRooms.Repo.Migrations.ChangeFromSpotifyToSoundcloud do
  use Ecto.Migration

  def change do
  	alter table(:rooms) do
	  remove :spotify_link
	  add :soundcloud_link, :string
	end
  end

end
