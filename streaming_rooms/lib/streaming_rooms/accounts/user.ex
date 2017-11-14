defmodule StreamingRooms.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset
  alias StreamingRooms.Accounts.User

  schema "users" do
    field :email, :string
    field :name, :string
    field :twitter_id, :integer
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(%User{} = user, attrs) do
    user
    |> cast(attrs, [:name, :username, :twitter_id, :email])
    |> validate_required([:name, :username, :twitter_id])
    |> unique_constraint(:twitter_id)
    |> validate_format(:email, ~r/@/)
  end
end
