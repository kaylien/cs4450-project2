defmodule StreamingRoomsWeb.ErrorController do
	
	use StreamingRoomsWeb, :controller

	def index(conn, _params) do
		render conn, "error.html"
	end

end
