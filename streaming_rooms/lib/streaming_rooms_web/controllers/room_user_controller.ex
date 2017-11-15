defmodule StreamingRoomsWeb.RoomUserController do
    use StreamingRoomsWeb, :controller

    alias StreamingRooms.Rooms
    alias StreamingRooms.Rooms.RoomUser

    action_fallback StreamingRoomsWeb.FallbackController

    def index(conn, _params) do
        rooms_users = Rooms.list_rooms_users()
        render(conn, "index.json", rooms_users: rooms_users)
    end

    def create(conn, %{"room_user" => room_user_params}) do
        with {:ok, %RoomUser{} = room_user} <- Rooms.create_room_user(room_user_params) do
            conn
            |> put_status(:created)
            |> put_resp_header("location", room_user_path(conn, :show, room_user))
            |> render("show.json", room_user: room_user)
        end
    end

    def show(conn, %{"id" => id}) do
        room_user = Rooms.get_room_user!(id)
        render(conn, "show.json", room_user: room_user)
    end

    def update(conn, %{"id" => id, "room_user" => room_user_params}) do
        room_user = Rooms.get_room_user!(id)

        with {:ok, %RoomUser{} = room_user} <- Rooms.update_room_user(room_user, room_user_params) do
            render(conn, "show.json", room_user: room_user)
        end
    end

    def delete(conn, %{"id" => id}) do
        room_user = Rooms.get_room_user!(id)
        with {:ok, %RoomUser{}} <- Rooms.delete_room_user(room_user) do
            send_resp(conn, :no_content, "")
        end
    end





    def what(conn, _params) do
        IO.inspect Rooms.get_users_that_stream_the_most(1)        
    end

end
