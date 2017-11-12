defmodule StreamingRoomsWeb.SessionController do
  use StreamingRoomsWeb, :controller

  # Log in to account 
  def login(conn, _params) do
  	response = TwitterModule.sign_in
  	redirect conn, external: response
  end

  def get_tokens(conn, params) do
	oauth_token = params["oauth_token"]
	oauth_verifier = params["oauth_verifier"]
	result = TwitterModule.get_access_token(oauth_token, oauth_verifier)
	if result == :ok do
		get_information_of_logged_user(conn, nil)
	else
		IO.puts elem(result, 1)
		IO.puts "ERROR"
		redirect conn, to: page_path(conn, :index)
	end
  end

  def logout(conn, _args) do
    conn
    |> put_session(:user_id, nil)
    # |> put_flash(:info, "Logged out")
    |> redirect(to: page_path(conn, :index))
  end

  defp get_information_of_logged_user(conn, _params) do
	try do
   	    credentials = TwitterModule.get_information_of_logged_user()
        redirect conn, to: hello_path(conn, :show, credentials[:username])
    rescue
        e in ExTwitter.Error ->
            IO.inspect {:error, e}
            redirect conn, to: page_path(conn, :index)
	end
  end

end
