defmodule Libra.PageView do
  @moduledoc false

  use Libra.Web, :view

  def render("show.html", %{page: page}) do
    result = encode_page(page)
    render("show.html", result: result)
  end

  def render("page.html", %{page: page}) do
    result = encode_page(page)
    render("page.html", result: result)
  end

  defp encode_page(page) do
    stylesheets = Enum.filter(page.assets, fn(asset) ->
      String.contains?(asset.url, ".css")
    end)
    scripts = Enum.filter(page.assets, fn(asset) ->
      String.contains?(asset.url, ".js")
    end)
    %{id: page.id,
      url: page.url,
      page_size: page.size,
      total_size: Libra.Page.total_size(page),
      stylesheets: stylesheets,
      scripts: scripts}
  end

  def format_size(size) do
    Sizeable.filesize(size)
  end
end
