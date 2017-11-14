defmodule TwitterModule do
  @moduledoc """
  Documentation for TwitterExperiment.
  """

  def sign_in do
    # Request twitter for a new token
    token = ExTwitter.request_token("http://localhost:4000/sessions/twitter") # Redirects to my page to give me oauth_token y oauth_verifier

    # Generate the url for "Sign-in with twitter".
    # For "3-legged authorization" use ExTwitter.authorize_url instead
    case ExTwitter.authenticate_url(token.oauth_token) do
      {:ok, authenticate_url} -> authenticate_url
    end
  end

  def get_access_token(oauth_token, oauth_verifier) do # This is going to handle the redirection
    case ExTwitter.access_token(oauth_verifier, oauth_token) do
      {:ok, access_token} -> handling_token(access_token)
      {:error, error_code} -> {:error, error_code}
    end
  end

  def handling_token(access_token) do
    # Configure ExTwitter to use your newly obtained access token
    ExTwitter.configure(
      consumer_key: Application.get_env(:streaming_rooms, :consumer_key),
      consumer_secret: Application.get_env(:streaming_rooms, :consumer_secret),
      access_token: access_token.oauth_token,
      access_token_secret: access_token.oauth_token_secret
    )
	  :ok # Return value
  end

  # Gets information of logged user
  def get_information_of_logged_user do
  	user = ExTwitter.verify_credentials
  	%{:twitter_id => user.id, :username => user.screen_name, :email => user.email, :name => user.name}
  end

end
