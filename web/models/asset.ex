defmodule Libra.Asset do
  @moduledoc """
  An asset represents a resource linked by a `Libra.Asset.Page`.
  """
  use Libra.Web, :model

  embedded_schema do
    field :url, :string
    field :size, :integer, default: 0
    field :status, Libra.Asset.Status, default: :unfetched
  end

  @type t :: %__MODULE__{url: String.t,
                         size: non_neg_integer,
                         status: Libra.Asset.Status.status}

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  @spec changeset(t, map) :: Ecto.Changeset.t
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:url, :status, :size])
    |> validate_required([:url])
  end

  @doc """
  Given an asset url and a page url, return the asset
  url with the correct host/protocol/port (taken from the page).

  If the supplied asset url already has a host/protocol/port, then
  it's returned untouched.

      iex> alias Libra.Asset
      iex> Asset.expand_url("/app.css", "http://localhost:4001/index.html")
      "http://localhost:4001/app.css"
      iex> Asset.expand_url("http://cdn.host.com/app.css", "http://localhost:4001/page.html")
      "http://cdn.host.com/app.css"
  """
  @spec expand_url(Inspect.url, Inspect.url) :: Inspect.url
  def expand_url(asset_url, page_url) do
    asset_uri = URI.parse(asset_url)
    do_expand_url(asset_uri, page_url)
    |> URI.to_string
  end

  defp do_expand_url(asset_uri = %{authority: nil}, page_url) do
    page_uri = URI.parse(page_url)
    %{asset_uri | authority: page_uri.authority,
      scheme: page_uri.scheme,
      host: page_uri.host,
      port: page_uri.port}
  end
  defp do_expand_url(asset_uri, _), do: asset_uri
end
