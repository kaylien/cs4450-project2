defmodule StreamingRooms.RoomsTest do
  use StreamingRooms.DataCase

  alias StreamingRooms.Rooms

  describe "rooms" do
    alias StreamingRooms.Rooms.Room

    @valid_attrs %{name: "some name", spotify_link: "some spotify_link", youtube_link: "some youtube_link"}
    @update_attrs %{name: "some updated name", spotify_link: "some updated spotify_link", youtube_link: "some updated youtube_link"}
    @invalid_attrs %{name: nil, spotify_link: nil, youtube_link: nil}

    def room_fixture(attrs \\ %{}) do
      {:ok, room} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Rooms.create_room()

      room
    end

    test "list_rooms/0 returns all rooms" do
      room = room_fixture()
      assert Rooms.list_rooms() == [room]
    end

    test "get_room!/1 returns the room with given id" do
      room = room_fixture()
      assert Rooms.get_room!(room.id) == room
    end

    test "create_room/1 with valid data creates a room" do
      assert {:ok, %Room{} = room} = Rooms.create_room(@valid_attrs)
      assert room.name == "some name"
      assert room.spotify_link == "some spotify_link"
      assert room.youtube_link == "some youtube_link"
    end

    test "create_room/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rooms.create_room(@invalid_attrs)
    end

    test "update_room/2 with valid data updates the room" do
      room = room_fixture()
      assert {:ok, room} = Rooms.update_room(room, @update_attrs)
      assert %Room{} = room
      assert room.name == "some updated name"
      assert room.spotify_link == "some updated spotify_link"
      assert room.youtube_link == "some updated youtube_link"
    end

    test "update_room/2 with invalid data returns error changeset" do
      room = room_fixture()
      assert {:error, %Ecto.Changeset{}} = Rooms.update_room(room, @invalid_attrs)
      assert room == Rooms.get_room!(room.id)
    end

    test "delete_room/1 deletes the room" do
      room = room_fixture()
      assert {:ok, %Room{}} = Rooms.delete_room(room)
      assert_raise Ecto.NoResultsError, fn -> Rooms.get_room!(room.id) end
    end

    test "change_room/1 returns a room changeset" do
      room = room_fixture()
      assert %Ecto.Changeset{} = Rooms.change_room(room)
    end
  end

  describe "rooms_users" do
    alias StreamingRooms.Rooms.RoomUser

    @valid_attrs %{in_room: true, joined: true, num_spotify_streams: 42, num_youtube_streams: 42}
    @update_attrs %{in_room: false, joined: false, num_spotify_streams: 43, num_youtube_streams: 43}
    @invalid_attrs %{in_room: nil, joined: nil, num_spotify_streams: nil, num_youtube_streams: nil}

    def room_user_fixture(attrs \\ %{}) do
      {:ok, room_user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Rooms.create_room_user()

      room_user
    end

    test "list_rooms_users/0 returns all rooms_users" do
      room_user = room_user_fixture()
      assert Rooms.list_rooms_users() == [room_user]
    end

    test "get_room_user!/1 returns the room_user with given id" do
      room_user = room_user_fixture()
      assert Rooms.get_room_user!(room_user.id) == room_user
    end

    test "create_room_user/1 with valid data creates a room_user" do
      assert {:ok, %RoomUser{} = room_user} = Rooms.create_room_user(@valid_attrs)
      assert room_user.in_room == true
      assert room_user.joined == true
      assert room_user.num_spotify_streams == 42
      assert room_user.num_youtube_streams == 42
    end

    test "create_room_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rooms.create_room_user(@invalid_attrs)
    end

    test "update_room_user/2 with valid data updates the room_user" do
      room_user = room_user_fixture()
      assert {:ok, room_user} = Rooms.update_room_user(room_user, @update_attrs)
      assert %RoomUser{} = room_user
      assert room_user.in_room == false
      assert room_user.joined == false
      assert room_user.num_spotify_streams == 43
      assert room_user.num_youtube_streams == 43
    end

    test "update_room_user/2 with invalid data returns error changeset" do
      room_user = room_user_fixture()
      assert {:error, %Ecto.Changeset{}} = Rooms.update_room_user(room_user, @invalid_attrs)
      assert room_user == Rooms.get_room_user!(room_user.id)
    end

    test "delete_room_user/1 deletes the room_user" do
      room_user = room_user_fixture()
      assert {:ok, %RoomUser{}} = Rooms.delete_room_user(room_user)
      assert_raise Ecto.NoResultsError, fn -> Rooms.get_room_user!(room_user.id) end
    end

    test "change_room_user/1 returns a room_user changeset" do
      room_user = room_user_fixture()
      assert %Ecto.Changeset{} = Rooms.change_room_user(room_user)
    end
  end
end
