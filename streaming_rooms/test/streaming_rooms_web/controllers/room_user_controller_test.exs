defmodule StreamingRoomsWeb.RoomUserControllerTest do
  use StreamingRoomsWeb.ConnCase

  alias StreamingRooms.Rooms
  alias StreamingRooms.Rooms.RoomUser

  @create_attrs %{in_room: true, joined: true, num_spotify_streams: 42, num_youtube_streams: 42}
  @update_attrs %{in_room: false, joined: false, num_spotify_streams: 43, num_youtube_streams: 43}
  @invalid_attrs %{in_room: nil, joined: nil, num_spotify_streams: nil, num_youtube_streams: nil}

  def fixture(:room_user) do
    {:ok, room_user} = Rooms.create_room_user(@create_attrs)
    room_user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all rooms_users", %{conn: conn} do
      conn = get conn, room_user_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create room_user" do
    test "renders room_user when data is valid", %{conn: conn} do
      conn = post conn, room_user_path(conn, :create), room_user: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, room_user_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "in_room" => true,
        "joined" => true,
        "num_spotify_streams" => 42,
        "num_youtube_streams" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, room_user_path(conn, :create), room_user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update room_user" do
    setup [:create_room_user]

    test "renders room_user when data is valid", %{conn: conn, room_user: %RoomUser{id: id} = room_user} do
      conn = put conn, room_user_path(conn, :update, room_user), room_user: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, room_user_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "in_room" => false,
        "joined" => false,
        "num_spotify_streams" => 43,
        "num_youtube_streams" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, room_user: room_user} do
      conn = put conn, room_user_path(conn, :update, room_user), room_user: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete room_user" do
    setup [:create_room_user]

    test "deletes chosen room_user", %{conn: conn, room_user: room_user} do
      conn = delete conn, room_user_path(conn, :delete, room_user)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, room_user_path(conn, :show, room_user)
      end
    end
  end

  defp create_room_user(_) do
    room_user = fixture(:room_user)
    {:ok, room_user: room_user}
  end
end
