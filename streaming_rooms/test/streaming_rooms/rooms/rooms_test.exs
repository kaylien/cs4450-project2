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
end
