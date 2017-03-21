defmodule Libra.Router do
  @moduledoc false

  use Libra.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", Libra do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :new
    resources "/pages", PageController, only: [:create, :show]
  end

  # Other scopes may use custom stacks.
  # scope "/api", Libra do
  #   pipe_through :api
  # end
end
