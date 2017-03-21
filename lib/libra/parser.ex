defmodule Libra.Parser do
  @moduledoc """
  This module is responsible to parse a page body and return
  all relevant information about it (see `Libra.Parser.Result`).

  See `Libra.Parser.parse_page/1` for usage example.
  """

  alias Libra.Parser.Result

  @doc """
  Parses a page, returning the result of the parse

      iex> page = "<html><head><script src='foo.js'></script></head></html>"
      iex> Libra.Parser.parse_page(page)
      %Libra.Parser.Result{size: 56,
                           stylesheets: [],
                           scripts: ["foo.js"]}

  """
  @spec parse_page(String.t) :: Result.t
  def parse_page(body) do
    %Result{size: byte_size(body),
            stylesheets: parse_stylesheets(body),
            scripts: parse_scripts(body)}
  end

  defp parse_stylesheets(body) do
    body
    |> Floki.find("link[rel=stylesheet]")
    |> Enum.flat_map(&(Floki.attribute(&1, "href")))
    |> Enum.uniq
  end

  defp parse_scripts(body) do
    body
    |> Floki.find("script[src]")
    |> Enum.flat_map(&(Floki.attribute(&1, "src")))
    |> Enum.uniq
  end
end
