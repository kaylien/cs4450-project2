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
  end

  pipeline :api do
    plug :accepts, ["json"]
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
    resources "/rooms", RoomController

  #  get "/holache", RoomUserController, :what

    # Default path if none of the above was invoked
    get "/error", ErrorController, :index
    # get "/*path", ErrorController, :index
  end

  # Other scopes may use custom stacks.
  scope "/api", StreamingRoomsWeb do
    pipe_through :api

    resources "/users", UserController, except: [:new, :edit]
    resources "/rooms_users", RoomUserController, except: [:new, :edit]

    patch "/rooms_users/:room_id/:user_id/spotify", RoomUserController, :increment_soundcloud_streams
    patch "/rooms_users/:room_id/:user_id/youtube", RoomUserController, :increment_youtube_streams
    get "/rooms_users/:room_id/spotify", RoomUserController, :get_soundcloud_streams_in_room
    get "/rooms_users/:room_id/youtube", RoomUserController, :get_youtube_streams_in_room

  end

end
