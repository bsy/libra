defmodule Libra.Client do
  @moduledoc """
  This module fetches resources via http and handles
  them to the relevant parser.
  """
  alias HTTPoison, as: H
  alias Libra.Parser

  @doc """
  Fetches and parses a page.
  """
  @spec fetch_page(String.t) :: {:ok, Parser.Result.t}
                              | {:error, term}
  def fetch_page(url) do
    case H.get(url, [], [follow_redirect: true]) do
      {:ok, resp} ->
        {:ok, Parser.parse_page(resp.body)}
      error ->
        error
    end
  end

  @doc """
  Fetches a resource, returning only its weight
  """
  @spec weigh_resource(String.t) :: {:ok, non_neg_integer}
                                  | {:error, term}
  def weigh_resource(url) do
    case H.get(url, [], [follow_redirect: true]) do
      {:ok, resp} ->
        {:ok, byte_size(resp.body)}
      error ->
        error
    end
  end
end
