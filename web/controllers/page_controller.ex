defmodule Libra.PageController do
  use Libra.Web, :controller

  alias Libra.Command

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"page_url" => url}) do
    case Command.InspectPage.run(url) do
      {:ok, page} ->
        Task.async(fn() -> Command.WeighResources.run(page) end)
        conn
        |> put_flash(:info, "Inspection done!")
        |> redirect(to: page_path(conn, :show, page.id))
      _error ->
        conn
        |> put_status(406)
        |> render("fail.html", url: url)
    end
  end

  def show(conn, %{"id" => page_id}) do
    page = Libra.Repo.get!(Libra.Page, page_id)
    render(conn, "show.html", page: page)
  end
end
