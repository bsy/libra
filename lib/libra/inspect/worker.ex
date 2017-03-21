defmodule Libra.Inspect.Worker do
  use GenServer
  alias Libra.{Asset, Page, Client}

  def start_link(url, uuid) do
    GenServer.start_link(__MODULE__, {url, uuid} , name: name(uuid))
  end

  def get_page(pid) when is_pid(pid) do
    GenServer.call(pid, :get_page)
  end

  def get_page(uuid) do
    GenServer.call(name(uuid), :get_page)
  end


  def init({url, uuid}) do
      page = %Page{id: uuid, url: url}
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
        GenServer.cast(self(), :weigh_resources)
        {:noreply, page}
      _error ->
        {:stop, :error_fetching_url}
    end
  end

  def handle_cast(:weigh_resources, page) do
    assets = page.assets
             |> Enum.map(fn(asset) -> weigh_asset(asset) end)

    page = %{page | assets: assets,
                    updated_at: Ecto.DateTime.utc()}
    {:noreply, page}
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

  defp weigh_asset(asset) do
    case Client.weigh_resource(asset.url) do
      {:ok, size} ->
         %{asset | size: size,
                   status: :fetched}
    _error ->
      %{asset | status: :failed}
    end
  end

  defp name(uuid) do
    {:via, Registry, {Registry.Page, uuid}}
  end

end
