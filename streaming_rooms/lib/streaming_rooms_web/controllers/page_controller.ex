defmodule StreamingRoomsWeb.PageController do
  use StreamingRoomsWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
