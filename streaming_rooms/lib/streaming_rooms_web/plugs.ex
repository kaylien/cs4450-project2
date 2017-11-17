defmodule StreamingRoomsWeb.Plugs do
    import Plug.Conn
    alias StreamingRoomsWeb.Router.Helpers, as: Routes

    def fetch_user(conn, _opts) do
        user_id = get_session(conn, :user_id)
        if user_id do
            user = StreamingRooms.Accounts.get_user!(user_id)
            assign(conn, :current_user, user)
        else
            assign(conn, :current_user, nil)
        end
    end

    def redirect_depending_on_status(conn, _opts) do
        user_id = get_session(conn, :user_id)
        request_path = conn.request_path
        IO.inspect request_path
        if (request_path == "/" || request_path == "/hello") do
           IO.inspect "KE"
           conn 
        else
            if ((request_path == "/sessions" || request_path == "/sessions/twitter") && user_id) do
                conn
                |> Phoenix.Controller.redirect(to: Routes.hello_path(conn, :index))
            else
                if (request_path != "/sessions" && request_path != "/sessions/twitter" && !user_id) do
                    conn
                    |> Phoenix.Controller.redirect(to: Routes.page_path(conn, :index))   
                else
                    conn
                end
            end
        end
    end

end
