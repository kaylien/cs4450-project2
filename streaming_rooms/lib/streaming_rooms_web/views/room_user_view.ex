defmodule StreamingRoomsWeb.RoomUserView do
  use StreamingRoomsWeb, :view
  alias StreamingRoomsWeb.RoomUserView

  def render("index.json", %{rooms_users: rooms_users}) do
    %{data: render_many(rooms_users, RoomUserView, "room_user.json")}
  end

  def render("show.json", %{room_user: room_user}) do
    %{data: render_one(room_user, RoomUserView, "room_user.json")}
  end

  def render("room_user.json", %{room_user: room_user}) do
    %{id: room_user.id,
      num_youtube_streams: room_user.num_youtube_streams,
      num_spotify_streams: room_user.num_spotify_streams,
      in_room: room_user.in_room,
      joined: room_user.joined}
  end
end
