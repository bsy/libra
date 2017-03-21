defmodule Libra.Asset.Status do
  @moduledoc """
  This module provides a custom Ecto type that represents
  the status of an asset: unfetched, fetched or failed.

  Can be used as:

  `field :status, Libra.Asset.Status, default: :unfetched`
  """
  @behaviour Ecto.Type

  @valid_statuses [:unfetched, :fetched, :failed]

  @type status :: :unfetched | :fetched | :failed

  @doc false
  @spec constraint_opts :: Keyword.t
  def constraint_opts do
    [name: "asset_status"]
  end

  @doc false
  @spec type :: :string
  def type, do: :string

  @doc false
  @spec cast(String.t | status) :: {:ok, String.t} | :error
  def cast(status) when is_binary(status) do
    {:ok, String.to_existing_atom(status)}
  end
  def cast(status) when status in @valid_statuses do
    {:ok, status}
  end
  def cast(_), do: :error

  @doc false
  @spec load(String.t) :: {:ok, status}
  def load(status) do
    {:ok, String.to_existing_atom(status)}
  end

  @doc false
  @spec dump(status) :: {:ok, String.t}
  def dump(status) do
    {:ok, Atom.to_string(status)}
  end
end
