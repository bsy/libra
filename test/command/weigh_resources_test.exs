defmodule Libra.Command.WeighResourcesTest do
  use Libra.ModelCase

  alias Libra.Command.{InspectPage, WeighResources}

  describe "page with valid asset urls" do
    setup do
      {:ok, old_page} = InspectPage.run("http://localhost:4001")
      {:ok, new_page} = WeighResources.run(old_page)
      {:ok, old_page: old_page, new_page: new_page}
    end

    test "saves the new page", %{old_page: old_page, new_page: new_page} do
      assert old_page.updated_at != new_page.updated_at
    end

    test "fetches all assets", %{new_page: new_page} do
      assert Enum.all?(new_page.assets, fn(a) ->
        a.status == :fetched and a.size > 0
      end)
    end
  end

  describe "page with invalid asset urls" do
    test "it saves assets as failed" do
      asset = %Libra.Asset{url: "http://localhost:4002/css/non-existing.css"}
      page = %Libra.Page{url: "http://localhost:4002", assets: [asset]}
             |> Libra.Repo.insert!

      {:ok, new_page} = WeighResources.run(page)
      [new_asset] = new_page.assets

      assert new_asset.status == :failed
    end
  end
end
