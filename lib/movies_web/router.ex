defmodule MoviesWeb.Router do
  use MoviesWeb, :router
  use Pow.Phoenix.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {MoviesWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :protected do
    plug Pow.Plug.RequireAuthenticated,
      error_handler: Pow.Phoenix.PlugErrorHandler
  end

  pipeline :admin_layout do
    plug :put_layout, {MoviesWeb.LayoutView, :torch}
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MoviesWeb do
    pipe_through :browser

    get "/", PageController, :index
  end

  scope "/admin", MoviesWeb.Admin, as: :admin do
    pipe_through [:browser, :protected, :admin_layout]

    get "/movies/search", MoviesController, :search
    get "/movies/watchlist", MoviesController, :add_to_watchlist
    get "/movies/index", MoviesController, :index
    get "/movies/delete", MoviesController, :delete

  end

  # Other scopes may use custom stacks.
  # scope "/api", MoviesWeb do
  #   pipe_through :api
  # end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: MoviesWeb.Telemetry
      pow_routes()
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
