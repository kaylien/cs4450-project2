defmodule StreamingRoomsWeb.Router do
  use StreamingRoomsWeb, :router
  import StreamingRoomsWeb.Plugs

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug :fetch_user
    plug :redirect_depending_on_status
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug :fetch_session
    plug :fetch_user
    # plug :redirect_depending_on_status
  end

  scope "/", StreamingRoomsWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
	  get "/hello", HelloController, :index
  	get "/hello/:message", HelloController, :show

    # Session handlers
	  get "/sessions", SessionController, :login
	  get "/sessions/twitter", SessionController, :get_tokens 
    delete "/session", SessionController, :logout

    # Room handler
    resources "/rooms", RoomController, except: [:index] 
    
    # Main page
    get "/main", RoomUserController, :get_rooms_user_is_not_joined_to
    post "/rooms_users/create/:room_id", RoomUserController, :create_room_user
    get "/rooms_users/joined", RoomUserController, :get_rooms_user_is_joined_to
    patch "/rooms_users/leave/:room_id", RoomUserController, :leave_room

    patch "/rooms_users/:room_id/not_in_room", RoomUserController, :update_user_not_in_room

    # Default path if none of the above was invoked
    get "/error", ErrorController, :index
    # get "/*path", ErrorController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", StreamingRoomsWeb do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
    # resources "/rooms_users", RoomUserController, except: [:new, :edit]

    patch "/rooms_users/:room_id/soundcloud", RoomUserController, :increment_soundcloud_streams
    patch "/rooms_users/:room_id/youtube", RoomUserController, :increment_youtube_streams

    patch "/rooms_users/:room_id/in_room", RoomUserController, :update_user_in_room
    # get "/rooms_users/rooms/:room_id/in_room", RoomUserController, :get_users_currently_in_room
  end

end
