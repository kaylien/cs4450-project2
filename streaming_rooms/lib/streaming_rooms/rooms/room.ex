defmodule StreamingRooms.Rooms.Room do
  use Ecto.Schema
  import Ecto.Changeset
  alias StreamingRooms.Rooms.Room


  schema "rooms" do
    field :name, :string
    field :spotify_link, :string
    field :youtube_link, :string
    belongs_to :admin_id, StreamingRooms.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(%Room{} = room, attrs) do
    room
    |> cast(attrs, [:name, :spotify_link, :youtube_link])
    |> validate_required([:name])
  end
end
