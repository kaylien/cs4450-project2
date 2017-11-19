defmodule StreamingRoomsWeb.UpdatesChannel do
  use StreamingRoomsWeb, :channel

  # def join("updates:lobby", payload, socket) do
  #   if authorized?(payload) do
  #     {:ok, socket}
  #   else
  #     {:error, %{reason: "unauthorized"}}
  #   end
  # end

  def join("room:"<> private_room_id, _payload, socket) do
      if authorized?(private_room_id) do
        {:ok, socket}
      else
        {:error, %{reason: "unauthorized"}}
      end
  end

  # # Channels can be used in a request/response fashion
  # # by sending replies to requests from the client
  # def handle_in("ping", payload, socket) do
  #   {:reply, {:ok, payload}, socket}
  # end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (updates:lobby).
  def handle_in("user_just_joined_room", payload, socket) do
    broadcast socket, "user_just_joined_room", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(room_id) do
      # For added security: 

      # result = StreamingRooms.Rooms.is_user_joined_to_room(socket.assigns., room_id)
      # if result == nil do # User doesn't belong to room
      #       false
      # else
      #     if result == [] do # User doesn't belong to room
      #         false
      #     else # User belongs to room
      #         true
      #     end
      # end
      true
  end

end