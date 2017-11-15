defmodule StreamingRooms.Rooms do
  @moduledoc """
  The Rooms context.
  """

  import Ecto.Query, warn: false
  alias StreamingRooms.Repo

  alias StreamingRooms.Rooms.Room

  @doc """
  Returns the list of rooms.

  ## Examples

      iex> list_rooms()
      [%Room{}, ...]

  """
  def list_rooms do
    Repo.all(Room)
  end

  @doc """
  Gets a single room.

  Raises `Ecto.NoResultsError` if the Room does not exist.

  ## Examples

      iex> get_room!(123)
      %Room{}

      iex> get_room!(456)
      ** (Ecto.NoResultsError)

  """
  def get_room!(id), do: Repo.get!(Room, id)

  @doc """
  Creates a room.

  ## Examples

      iex> create_room(%{field: value})
      {:ok, %Room{}}

      iex> create_room(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_room(attrs \\ %{}) do
    %Room{}
    |> Room.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a room.

  ## Examples

      iex> update_room(room, %{field: new_value})
      {:ok, %Room{}}

      iex> update_room(room, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_room(%Room{} = room, attrs) do
    room
    |> Room.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Room.

  ## Examples

      iex> delete_room(room)
      {:ok, %Room{}}

      iex> delete_room(room)
      {:error, %Ecto.Changeset{}}

  """
  def delete_room(%Room{} = room) do
    Repo.delete(room)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking room changes.

  ## Examples

      iex> change_room(room)
      %Ecto.Changeset{source: %Room{}}

  """
  def change_room(%Room{} = room) do
    Room.changeset(room, %{})
  end

  alias StreamingRooms.Rooms.RoomUser

  @doc """
  Returns the list of rooms_users.

  ## Examples

      iex> list_rooms_users()
      [%RoomUser{}, ...]

  """
  def list_rooms_users do
    Repo.all(RoomUser)
  end

  @doc """
  Gets a single room_user.

  Raises `Ecto.NoResultsError` if the Room user does not exist.

  ## Examples

      iex> get_room_user!(123)
      %RoomUser{}

      iex> get_room_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_room_user!(id), do: Repo.get!(RoomUser, id)

  @doc """
  Creates a room_user.

  ## Examples

      iex> create_room_user(%{field: value})
      {:ok, %RoomUser{}}

      iex> create_room_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_room_user(attrs \\ %{}) do
    %RoomUser{}
    |> RoomUser.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a room_user.

  ## Examples

      iex> update_room_user(room_user, %{field: new_value})
      {:ok, %RoomUser{}}

      iex> update_room_user(room_user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_room_user(%RoomUser{} = room_user, attrs) do
    room_user
    |> RoomUser.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a RoomUser.

  ## Examples

      iex> delete_room_user(room_user)
      {:ok, %RoomUser{}}

      iex> delete_room_user(room_user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_room_user(%RoomUser{} = room_user) do
    Repo.delete(room_user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking room_user changes.

  ## Examples

      iex> change_room_user(room_user)
      %Ecto.Changeset{source: %RoomUser{}}

  """
  def change_room_user(%RoomUser{} = room_user) do
    RoomUser.changeset(room_user, %{})
  end

  ################################################################################################
  ###                                                                                          ###
  ###                                      CUSTOM FUNCTIONS                                    ###
  ###                                                                                          ###
  ################################################################################################


  ###############################################
  ##              NUMBERS SECTION              ##
  ###############################################

  # Increments by one the Soundcloud numbers based on the room and user
  def increment_soundcloud_streams(room_id, user_id) do
    query = from ru in RoomUser,
                where: ru.room_id == ^room_id and ru.user_id == ^user_id,
                select: ru.num_soundcloud_streams
    result = Repo.all(query)
    resultIncremented = List.first(result) + 1
    from(ru in RoomUser, where: ru.room_id == ^room_id 
          and ru.user_id == ^user_id, update: [set: [num_soundcloud_streams: ^resultIncremented]])
    |> Repo.update_all([])
  end

  # Increments by one the Youtube numbers based on the room and user
  def increment_youtube_streams(room_id, user_id) do
    query = from ru in RoomUser,
                where: ru.room_id == ^room_id and ru.user_id == ^user_id,
                select: ru.num_youtube_streams
    result = Repo.all(query)
    resultIncremented = List.first(result) + 1
    from(ru in RoomUser, where: ru.room_id == ^room_id 
          and ru.user_id == ^user_id, update: [set: [num_youtube_streams: ^resultIncremented]])
    |> Repo.update_all([])
  end

  # Gets total Soundcloud streams in one room
  def get_soundcloud_streams_in_room(room_id) do
    query = from ru in RoomUser,
            where: ru.room_id == ^room_id,
            select: sum(ru.num_soundcloud_streams)
    result = Repo.all(query)
    if (result != [nil]) do
      Decimal.to_integer(List.first(result))
    else 
      # DO SOMETHING
    end
  end

  # Gets total Youtube streams in one room
  def get_youtube_streams_in_room(room_id) do
    query = from ru in RoomUser,
            where: ru.room_id == ^room_id,
            select: sum(ru.num_youtube_streams)

    result = Repo.all(query)
    if (result != [nil]) do
      Decimal.to_integer(List.first(result))
    else 
      0
    end
  
  end

  # Gets list of users that stream the most based on both Youtube + Soundcloud numbers
  def get_users_that_stream_the_most(room_id) do
    query = from ru in RoomUser,
            where: ru.room_id == ^room_id,
            order_by: [desc: fragment("? + ?", ru.num_youtube_streams, ru.num_soundcloud_streams)],
            select: {ru.user_id, fragment("? + ?", ru.num_youtube_streams, ru.num_soundcloud_streams)}
    Repo.all(query)
  end


  ###############################################
  ##             USER-ROOM FUNCTIONS           ##
  ###############################################

  def get_rooms_user_is_joined_to(user_id) do
      query = from ru in RoomUser,
                join: r in Room,
                where: ru.user_id == ^user_id and ru.room_id == r.id and ru.joined == true,
                select: r
      Repo.all(query)
  end

  def get_rooms_user_is_not_joined_to(user_id) do
      result = get_rooms_user_is_joined_to(user_id)
      ids = Enum.map(result, fn x -> x.id end) # Get just the ids of the rooms
      query = from r in Room,
                where: r.id not in ^ids,
                limit: 30,
                select: r
      Repo.all(query)
  end

  def get_users_currently_in_room(room_id) do
      query = from ru in RoomUser,
                join: u in StreamingRooms.Accounts.User,
                where: ru.room_id == ^room_id and ru.user_id == u.id and ru.in_room == true,
                select: u
      Repo.all(query)
  end

end
