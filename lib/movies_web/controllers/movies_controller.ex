defmodule MoviesWeb.Admin.MoviesController do
  use MoviesWeb, :controller

  alias Movies.HTTP.API, as: HTTPClient
  import Ecto.Query, warn: false
  alias Movies.Repo
  alias Movies.Movie
alias Movies.Users.User

  def search(conn, %{"search" => movie_name}) do
    path = "https://api.themoviedb.org/3/search/movie?api_key=7e719bfe3cd3786ebf0a05d3b138853d"
    with_spaces = URI.encode_query(%{"query" => movie_name})

    IO.inspect("#{path}&#{with_spaces}")

    case HTTPClient.get("#{path}&#{with_spaces}") do
      {:ok, response} ->
        {:ok, Jason.decode!(response.body)}
        r = Jason.decode!(response.body)
        render(conn, "movies.html", movies: r["results"])

      {:error, error} ->
        # Logger.error("Error getting prices, #{inspect(error)}")
        {:error, error}
    end
  end

  def add_to_watchlist(conn, params) do
    IO.inspect(params)
    params = %{name: params["original_title"], movie_id: params["id"], user_id: 1}
    c = Movie.changeset(%Movie{}, params)
    IO.inspect(c, label: "chagestet")
    Repo.insert(c)
    conn
    |> redirect(to: Routes.admin_movies_path(conn, :index))
  end

  @spec index(Plug.Conn.t(), any) :: Plug.Conn.t()
  def index(conn, params) do
    IO.inspect params, label: "params"
    current_user = conn.assigns[:current_user]
    IO.inspect current_user.email
    e = current_user.email
    #assigns = Repo.all(from m in Movie, where: m.email == ^current_user, select: m.name )
    assigns = Repo.get_by(User, email: e)
    IO.inspect assigns
    IO.puts "1"
    a = assigns
    |> Repo.preload([:movies])
    IO.puts "11"
    IO.inspect a
    movies_list = a.movies
    IO.inspect movies_list, label: "list"
    render(conn, "index.html", movies: movies_list)

  end


  def delete(conn, %{"movie_id" => movie_id}) do
    IO.puts "hjerer"
    IO.inspect movie_id, label: "deleting this guy"
    #Repo.delete(movie_id)
    from(x in Movie, where: x.id == ^movie_id) |> Repo.delete_all


    conn
    |> redirect(to: Routes.admin_movies_path(conn, :index))

  end
end
