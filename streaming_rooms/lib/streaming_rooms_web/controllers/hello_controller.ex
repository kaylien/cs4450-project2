defmodule StreamingRoomsWeb.HelloController do
  use StreamingRoomsWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def show(conn, %{"message" => variable}) do
	render conn, "show.html", message: variable
  end

end
