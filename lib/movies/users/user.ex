defmodule Movies.Users.User do
  use Ecto.Schema
  use Pow.Ecto.Schema

  schema "users" do
    pow_user_fields()
    has_many :movies, Movies.Movie
    timestamps()
  end
end
