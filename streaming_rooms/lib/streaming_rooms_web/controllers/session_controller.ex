defmodule StreamingRoomsWeb.SessionController do
    use StreamingRoomsWeb, :controller

    alias StreamingRooms.Accounts

    # Log in to account 
    def login(conn, _params) do
        # if get_session(conn, :user_id) != nil do
        #     redirect conn, to: hello_path(conn, :show, "Already logged in!!!")
        # else
          	response = TwitterModule.sign_in
          	redirect conn, external: response
        # end
    end

    # Gets tokens from Twitter
    def get_tokens(conn, params) do
        # if get_session(conn, :user_id) != nil do
        #     redirect conn, to: room_user_path(conn, :show, "Already logged in!!!")
        # else
          	oauth_token = params["oauth_token"]
          	oauth_verifier = params["oauth_verifier"]
          	result = TwitterModule.get_access_token(oauth_token, oauth_verifier)
          	if result == :ok do # Could get access token
          		  get_information_of_logged_user(conn, nil)
          	else # Couldn't get access token
          		  redirect conn, to: error_path(conn, :index)
          	end
        # end
    end

    # Gets information from Twitter
    defp get_information_of_logged_user(conn, _params) do
      	try do
       	    credentials = TwitterModule.get_information_of_logged_user()
            
            # Get information about users
            try do
                user = Accounts.get_user_by_twitter_id!(credentials[:twitter_id]) # Will throw NoResultsError if no user is found on DB
                
                # Check if information about user has been updated on Twitter and update it on local DB
                if user.username != credentials[:username] do
                  Map.put(user, :username, credentials[:username])
                end
                if user.name != credentials[:name] do
                  Map.put(user, :name, credentials[:name])
                end
                if user.email != credentials[:email] do
                  Map.put(user, :email, credentials[:email])
                end

                # Put information into session
                conn 
                |> put_session(:user_id, user.id)
                |> redirect(to: room_user_path(conn, :get_rooms_user_is_not_joined_to))

            rescue _e in Ecto.NoResultsError -> 
                user = %Accounts.User{:twitter_id => credentials.twitter_id, 
                                      :username => credentials.username, 
                                      :email => credentials.email, 
                                      :name => credentials.name}
                try do
                    {:ok, result} = Accounts.insert_user(user)  # Will throw ContraintError if can't insert user
                    conn
                    |> put_session(:user_id, result.id)
                    |> redirect(to: room_user_path(conn, :get_rooms_user_is_not_joined_to))
                rescue
                    _e in Ecto.ConstraintError ->
                        IO.puts "CONSTRAINT ERROR!"
                        redirect conn, to: error_path(conn, :index)
                end
            end
        rescue
            e in ExTwitter.Error ->
                IO.inspect {:error, e}
                redirect conn, to: page_path(conn, :index)
      	end
    end

    # Log out of session
    def logout(conn, _args) do
        conn
        |> put_session(:user_id, nil)
        |> redirect(to: page_path(conn, :index))
    end

end
