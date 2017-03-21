defmodule Libra.Command.InspectPageTest do
  use Libra.ModelCase

  alias Libra.Command.InspectPage

  describe "valid url" do
    setup do
      {:ok, page} = InspectPage.run("http://localhost:4001")
      {:ok, page: page}
    end

    test "saves page to db", %{page: page} do
      assert page.url == "http://localhost:4001"
      assert page == Libra.Repo.get!(Libra.Page, page.id)
    end

    test "saves correct assets", %{page: page} do
      expected_urls = ["http://localhost:4001/css/app.css",
                       "http://localhost:4001/js/app.js"]

      actual_urls = page.assets
                    |> Enum.map(&(&1.url))
                    |> Enum.sort

      assert expected_urls == actual_urls
    end
  end

  describe "invalid url" do
    test "returns an error" do
      assert {:error, _reason} = InspectPage.run("http://localhost:4002")
    end

    test "doesn't save the page" do
      InspectPage.run("http://localhost:4002")

      assert nil == Libra.Repo.get_by(Libra.Page, [url: "http://localhost:4002"])
    end
  end
end
