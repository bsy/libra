defmodule Libra.Command.WeighResources do
  alias Libra.Client

  alias Libra.Endpoint

  @spec run(Libra.Page.t) :: {:ok, Libra.Page.t} | {:error, term}
  def run(page) do
    case update_page(page) do
      {:ok, new_page} ->
        Endpoint.broadcast("page:" <> new_page.id, "page-update", new_page)
        {:ok, new_page}
      error ->
        error
    end
  end

  defp update_page(page) do
    asset_changesets = Enum.map(page.assets, &weigh_asset/1)
    changeset = Ecto.Changeset.change(page)
                |> Ecto.Changeset.put_embed(:assets, asset_changesets)
    Libra.Repo.update(changeset)
  end

  defp weigh_asset(asset) do
    case Client.weigh_resource(asset.url) do
      {:ok, size} ->
        Libra.Asset.changeset(asset, %{size: size,
                                       status: :fetched})
    _error ->
        Libra.Asset.changeset(asset, %{status: :failed})
    end
  end
end
