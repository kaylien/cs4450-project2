defmodule StreamingRooms.Rooms.RoomUser do
    use Ecto.Schema
    import Ecto.Changeset
    alias StreamingRooms.Rooms.RoomUser

    schema "rooms_users" do
        field :in_room, :boolean, default: true
        field :joined, :boolean, default: true
        field :num_soundcloud_streams, :integer, default: 0
        field :num_youtube_streams, :integer, default: 0
        belongs_to :room, StreamingRooms.Rooms.Room
        belongs_to :user, StreamingRooms.Accounts.User

        timestamps()
    end

    @doc false
    def changeset(%RoomUser{} = room_user, attrs) do
        room_user
        |> cast(attrs, [:num_youtube_streams, :num_soundcloud_streams, :in_room, :joined, :room_id, :user_id])
        |> validate_required([:user_id, :room_id])
        |> assoc_constraint(:room)
        |> assoc_constraint(:user)
    end
end
