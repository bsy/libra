defmodule Libra.PageChannel do
  use Libra.Web, :channel

  intercept ["page-update"]

  alias Libra.{Page, PageView, Repo}

  def join("page:" <> page_id, _payload, socket) do
    case Repo.get(Page, page_id) do
      nil ->
        {:error, %{reason: "page not found"}}
      page ->
        send(self(), {:page_update, page})
        {:ok, socket}
    end
  end

  def handle_out("page-update", page, socket) do
    push_page_status(page, socket)
    {:noreply, socket}
  end

  def handle_info({:page_update, page}, socket) do
    push_page_status(page, socket)
    {:noreply, socket}
  end

  defp push_page_status(page, socket) do
    payload = Phoenix.View.render_to_string(PageView,
                                            "page.html",
                                            %{page: page})
    push(socket, "page-update", %{results: payload})
  end
end
