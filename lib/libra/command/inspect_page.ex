defmodule Libra.Command.InspectPage do
  alias Libra.Client

  @spec run(String.t) :: {:ok, Libra.Page.t} | {:error, term}
  def run(url) do
    case Client.fetch_page(url) do
      {:ok, result} ->
        params = %{
          url: url,
          size: result.size,
          assets: build_assets(result, url)
        }
        changeset = Libra.Page.changeset(%Libra.Page{}, params)
        Libra.Repo.insert(changeset)
      error ->
        error
    end
  end

  defp build_assets(result, url) do
    (result.stylesheets ++ result.scripts)
    |> Enum.map(fn(asset) ->
      asset_url = Libra.Asset.expand_url(asset, url)
      %{url: asset_url,
        status: :unfetched}
    end)
  end
end
