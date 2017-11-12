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
	get "/sessions", SessionController, :login
	get "/sessions/twitter", SessionController, :get_tokens 
  end

  # Other scopes may use custom stacks.
  # scope "/api", StreamingRoomsWeb do
  #   pipe_through :api
  # end
end
