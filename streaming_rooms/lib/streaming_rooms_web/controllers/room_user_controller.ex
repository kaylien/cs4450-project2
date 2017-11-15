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

  ################################################################################################
  ###                                                                                          ###
  ###                                      CUSTOM FUNCTIONS                                    ###
  ###                                                                                          ###
  ################################################################################################


  ###############################################
  ##              NUMBERS SECTION              ##
  ###############################################


  def increment_soundcloud_streams(conn, %{"room_id" => room_id, "user_id" => user_id}) do
        result_db = Rooms.increment_soundcloud_streams(room_id, user_id)
        if elem(result_db, 0) == 0 do
           send_resp(conn, 404, "WRONG") 
        else
            send_resp(conn, 200, "OK!")
        end
  end


  def increment_youtube_streams(conn, %{"room_id" => room_id, "user_id" => user_id}) do
        result_db = Rooms.increment_youtube_streams(room_id, user_id)
        if elem(result_db, 0) == 0 do
           send_resp(conn, 404, "WRONG") 
        else
            send_resp(conn, 200, "OK!")
        end
  end


  def get_soundcloud_streams_in_room(conn, %{"room_id" => room_id}) do
      amount_of_streams = Rooms.get_soundcloud_streams_in_room(room_id)
      if (amount_of_streams == nil) do
           send_resp(conn, 404, "WRONG")
      else
           send_resp(conn, 200, Integer.to_string(amount_of_streams))  
      end
  end


  def get_youtube_streams_in_room(conn, %{"room_id" => room_id}) do
      amount_of_streams = Rooms.get_youtube_streams_in_room(room_id)
      if (amount_of_streams == nil) do
           send_resp(conn, 404, "WRONG")
      else
           send_resp(conn, 200, Integer.to_string(amount_of_streams))  
      end
  end


  def get_users_that_stream_the_most(conn, %{"room_id" => room_id}) do
        list_of_users = Rooms.get_users_that_stream_the_most(room_id)
        result = Enum.into(list_of_users, %{})
        result_with_users = %{:list => result}
        # Try to convert map to json
        try do
            json_result = Poison.encode!(Map.put(result_with_users, :result, :ok))
            conn 
            |> put_resp_content_type("application/json")
            |> send_resp(200, json_result)
        rescue 
            _e in Poison.EncodeError ->
                conn
                |> send_resp(500, Poison.encode!(
                    %{:result => :error, :message => "There was an error internal error, try again!"}
                ))
        end
  end

end
