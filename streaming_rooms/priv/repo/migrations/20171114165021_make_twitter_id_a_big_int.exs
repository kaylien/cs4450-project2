defmodule StreamingRooms.Repo.Migrations.MakeTwitterIdABigInt do
  use Ecto.Migration

  def change do
  	alter table(:users) do
	  remove :twitter_id
	  add :twitter_id, :bigint
	end
  end
  
end
