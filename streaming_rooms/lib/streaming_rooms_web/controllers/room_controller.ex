defmodule StreamingRoomsWeb.RoomController do
  use StreamingRoomsWeb, :controller

  alias StreamingRooms.Rooms
  alias StreamingRooms.Rooms.Room

  def index(conn, _params) do
    rooms = Rooms.list_rooms()
    render(conn, "index.html", rooms: rooms)
  end

  def new(conn, _params) do
    changeset = Rooms.change_room(%Room{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"room" => room_params}) do
    case Rooms.create_room(room_params) do
      {:ok, room} ->
          case Rooms.create_room_user(%{:room_id => room.id, :user_id => conn.assigns.current_user.id}) do
              {:ok, _result} -> 
                  conn
                  |> put_flash(:info, "Room created successfully!")
                  |> redirect(to: room_path(conn, :show, room.id))
              {:error, _error} ->
                  Rooms.delete_room(room)
                  conn
                  |> put_flash(:error, "Room couldn't be created!")
                  |> redirect(to: room_user_path(conn, :get_rooms_user_is_not_joined_to))
          end
      {:error, %Ecto.Changeset{} = changeset} ->
          conn
          |> render("new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
      result = Rooms.is_user_joined_to_room(conn.assigns.current_user.id, id)
      if result == nil do # User doesn't belong to room
            redirect(conn, to: room_user_path(conn, :get_rooms_user_is_not_joined_to))
      else
          if result == [] do # User doesn't belong to room
              conn
              |> redirect(to: room_user_path(conn, :get_rooms_user_is_not_joined_to))
          else # User belongs to room
              room = Rooms.get_room!(id)
              render(conn, "show.html", room: room)
          end
      end
  end

  def edit(conn, %{"id" => id}) do
    room = Rooms.get_room!(id)
    changeset = Rooms.change_room(room)
    render(conn, "edit.html", room: room, changeset: changeset)
  end

  def update(conn, %{"id" => id, "room" => room_params}) do
    room = Rooms.get_room!(id)

    case Rooms.update_room(room, room_params) do
      {:ok, room} ->
        conn
        |> put_flash(:info, "Room updated successfully.")
        |> redirect(to: room_path(conn, :show, room))
      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", room: room, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    room = Rooms.get_room!(id)
    {:ok, _room} = Rooms.delete_room(room)

    conn
    |> put_flash(:info, "Room deleted successfully.")
    |> redirect(to: room_path(conn, :index))
  end

end
