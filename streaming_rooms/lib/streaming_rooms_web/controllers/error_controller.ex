defmodule StreamingRoomsWeb.ErrorController do
  use StreamingRoomsWeb, :controller

  def index(conn, _params) do
  	IO.puts "SHOULD GET HERE!"
    render conn, "error.html"
  end

end
