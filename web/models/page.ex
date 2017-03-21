defmodule Libra.Page do
  @moduledoc """
  A page represents the result of a url inspection and it embeds
  zero or more asset (`Libra.Asset`).
  """
  use Libra.Web, :model

  schema "pages" do
    field :url, :string
    field :size, :integer, default: 0
    embeds_many :assets, Libra.Asset

    timestamps()
  end

  @type t :: %__MODULE__{__meta__: %Ecto.Schema.Metadata{},
                         id: nil | String.t,
                         url: nil | String.t,
                         size: non_neg_integer,
                         assets: [Libra.Asset.t],
                         inserted_at: nil | %Ecto.DateTime{},
                         updated_at: nil | %Ecto.DateTime{}}

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  @spec changeset(t, map) :: Ecto.Changeset.t | no_return
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:url, :size])
    |> cast_embed(:assets)
    |> validate_required([:url])
  end

  @doc """
  Returns the total size (in bytes) of a page and all of its assets.

      iex> alias Libra.{Asset, Page}
      iex> assets = [%Asset{size: 10}, %Asset{size: 15}]
      iex> page = %Page{size: 1, assets: assets}
      iex> Page.total_size(page)
      26
  """
  @spec total_size(t) :: non_neg_integer
  def total_size(page) do
    Enum.reduce(page.assets, page.size, fn(asset, total) ->
      asset.size + total
    end)
  end
end
