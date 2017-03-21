defmodule Libra.PageTest do
  use Libra.ModelCase
  doctest Libra.Page

  alias Libra.{Asset, Page}

  @valid_attrs %{
    url: "http://localhost:4001",
    size: 12345,
    assets: [
      %{url: "http://localhost:4001/app.css",
        status: :unfetched,
        size: 0},
      %{url: "http://localhost:4001/app.js",
        status: :unfetched,
        size: 0}
    ]}

  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Page.changeset(%Page{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Page.changeset(%Page{}, @invalid_attrs)
    refute changeset.valid?
  end
end
