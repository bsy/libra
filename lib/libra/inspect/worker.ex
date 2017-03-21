defmodule Libra.Inspect.Worker do
  use GenServer
  alias Libra.{Asset, Page, Client}

  def start_link(url) do
    GenServer.start_link(__MODULE__, url)
  end

  def get_page(pid) do
    GenServer.call(pid, :get_page)
  end

  def init(url) do
      page = %Page{url: url}
      GenServer.cast(self(), :inspect_page)
      {:ok, page}
  end

  # add overrides for default callback
  def handle_call(:get_page, _from, page) do
    {:reply, page, page}
  end

  def handle_cast(:inspect_page, page) do
    case Client.fetch_page(page.url) do
      {:ok, result} ->
        page = %{page | size: result.size,
                        assets: build_assets(result, page.url),
                        inserted_at: Ecto.DateTime.utc(),
                        updated_at: Ecto.DateTime.utc()}
        {:noreply, page}
      _error ->
        {:stop, :error_fetching_url}
    end

  end

  defp build_assets(result, url) do
    (result.stylesheets ++ result.scripts)
    |> Enum.map(fn(asset) ->
      asset_url = Asset.expand_url(asset, url)
      %Asset{id: Ecto.UUID.generate(),
             url: asset_url,
             status: :unfetched}
    end)
  end

end
