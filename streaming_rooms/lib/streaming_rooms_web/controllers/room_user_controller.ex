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
  ##           ERROR MESSAGES SECTION          ##
  ###############################################


  defp send_error_message(conn, status_code, message) do
      send_resp(conn, status_code, Poison.encode!(%{:result => :error, :message => message}))
  end

  defp internal_error_message(conn) do
      conn |> render(500, Poison.encode!(%{:result => :error, :message => "There was an error internal error, try again!"}))
  end


  ###############################################
  ##              NUMBERS SECTION              ##
  ###############################################


  def increment_soundcloud_streams(conn, %{"room_id" => room_id}) do
        result_db = Rooms.increment_soundcloud_streams(room_id, conn.assigns.current_user.id)
        try do
            if elem(result_db, 0) == 0 do
               send_error_message(conn, 404, "Incorrect user and/or room")
            else
                send_resp(conn, 200, Poison.encode!(%{:result => :ok}))
            end
        rescue 
           _e in Poison.EncodeError ->
              internal_error_message(conn)
        end
  end


  def increment_youtube_streams(conn, %{"room_id" => room_id}) do
        result_db = Rooms.increment_youtube_streams(room_id, conn.assigns.current_user.id)
        try do
            if elem(result_db, 0) == 0 do
               send_error_message(conn, 404, "Incorrect user and/or room")
            else
                send_resp(conn, 200, Poison.encode!(%{:result => :ok}))
            end
        rescue 
           _e in Poison.EncodeError ->
              internal_error_message(conn)
        end
  end


  def get_soundcloud_streams_in_room(conn, %{"room_id" => room_id}) do
      amount_of_streams = Rooms.get_soundcloud_streams_in_room(room_id)
      try do
          if (amount_of_streams == nil) do
               send_error_message(conn, 404, "There are no users in the room supplied")
          else
               send_resp(conn, 200, Poison.encode!(%{:result => :ok, :soundcloud_streams => amount_of_streams})) 
          end
      rescue 
          _e in Poison.EncodeError ->
            internal_error_message(conn)
      end
  end


  def get_youtube_streams_in_room(conn, %{"room_id" => room_id}) do
      amount_of_streams = Rooms.get_youtube_streams_in_room(room_id)
      try do
          if (amount_of_streams == nil) do
               send_error_message(conn, 404, "There are no users in the room supplied")
          else
               send_resp(conn, 200, Poison.encode!(%{:result => :ok, :youtube_streams => amount_of_streams}))
          end
      rescue 
          _e in Poison.EncodeError ->
            internal_error_message(conn)
      end
  end


  def get_users_that_stream_the_most(conn, %{"room_id" => room_id}) do
        list_of_users = Rooms.get_users_that_stream_the_most(room_id)
        result = Enum.into(list_of_users, %{})
        result_with_users = %{:ranking => result}
        # Try to convert map to json
        try do
            json_result = Poison.encode!(Map.put(result_with_users, :result, :ok))
            conn 
            |> put_resp_content_type("application/json")
            |> send_resp(200, json_result)
        rescue 
            _e in Poison.EncodeError ->
                internal_error_message(conn)
        end
  end


  ###############################################
  ##             USER-ROOM FUNCTIONS           ##
  ###############################################

  def create_room_user(conn, %{"room_id" => room_id}) do
      result = Rooms.join_room_once_again(conn.assigns.current_user.id, room_id)
      if result == nil || elem(result, 0) == 0 do
          case Rooms.create_room_user(%{:room_id => room_id, :user_id => conn.assigns.current_user.id}) do
            {:ok, result} -> 
                conn
                |> put_flash(:info, "You are now joined to the room!")
                |> redirect(to: room_path(conn, :show, room_id))
            {:error, error} ->
                conn
                |> put_flash(:error, "You couldn't join room. Try again!")
                |> redirect(to: room_user_path(conn, :get_rooms_user_is_not_joined_to))
          end
      else
          conn
          |> put_flash(:info, "You are now joined to the room!")
          |> redirect(to: room_path(conn, :show, room_id))
      end
  end


  def leave_room(conn, %{"room_id" => room_id}) do
      result_db = Rooms.leave_room(conn.assigns.current_user.id, room_id)
      if result_db == nil || elem(result_db, 0) == 0 do
          conn
          |> put_flash(:info, "You couldn't leave the room!")
          |> redirect(to: room_user_path(conn, :get_rooms_user_is_joined_to))
      else
          conn
          |> put_flash(:info, "You left to the room!")
          |> redirect(to: room_user_path(conn, :get_rooms_user_is_joined_to))
      end
  end


  def get_rooms_user_is_joined_to(conn, _params) do
      result = Rooms.get_rooms_user_is_joined_to(conn.assigns.current_user.id)
      if result == nil do
            send_error_message(conn, 404, "The user supplied is invalid")
      else
          result_as_map = Enum.map(result, fn {id, name} -> %{:id => id, :name => name} end)
          render(conn, "joined.html", rooms: result_as_map)
          #try do
          #      auxiliar = Map.put(%{:result => :ok}, :list, result_as_map)
          #      send_resp(conn, 200, Poison.encode!(auxiliar))
          #rescue 
          #      _e in Poison.EncodeError ->
          #          internal_error_message(conn)
          #end
        end
  end


  def get_rooms_user_is_not_joined_to(conn, _params) do
      result = Rooms.get_rooms_user_is_not_joined_to(conn.assigns.current_user.id)
      if result == nil do
            send_error_message(conn, 404, "The user supplied is invalid")
      else
          result_as_map = Enum.map(result, fn {id, name} -> %{:id => id, :name => name} end)
          render(conn, "main.html", rooms: result_as_map)
          # try do
          #       auxiliar = Map.put(%{:result => :ok}, :list, result_as_map)
          #       send_resp(conn, 200, Poison.encode!(auxiliar))
          # rescue 
          #       _e in Poison.EncodeError ->
          #           internal_error_message(conn)
          # end
      end
  end

  def get_users_currently_in_room(conn, %{"room_id" => room_id}) do
      result = Rooms.get_users_currently_in_room(room_id)
      if result == nil do
            send_error_message(conn, 404, "The room supplied is invalid")
      else
          result_as_map = Enum.map(result, fn {id, username} -> %{:user_id => id, :username => username} end)
          try do
                auxiliar = Map.put(%{:result => :ok}, :list, result_as_map)
                send_resp(conn, 200, Poison.encode!(auxiliar))
          rescue 
                _e in Poison.EncodeError ->
                    internal_error_message(conn)
          end
      end
  end


end
