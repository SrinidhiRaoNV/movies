defmodule Movies.Movie do
  use Ecto.Schema
  import Ecto.Changeset


  schema "movies" do
    field :movie_id, :string
    field :name, :string
    belongs_to(:user, Movies.Users.User)
  end


  def changeset(movie, attrs) do
    movie
    |> cast(attrs, [:movie_id, :name, :user_id])
    |> validate_required([:movie_id, :name, :user_id])
    |> unique_constraint([:user_id, :name])
  end

end
