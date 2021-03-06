defmodule Libra.Inspect.WorkerTest do
  use ExUnit.Case

  alias Libra.Inspect.Worker

  describe "fetches a url" do
    setup do
      uuid = Ecto.UUID.generate()
      {:ok, worker} = Worker.start_link("http://localhost:4001", uuid)
      {:ok, worker: worker, uuid: uuid}
    end

    test "read a page", %{worker: worker} do
      page = Worker.get_page(worker)

      assert(page.url == "http://localhost:4001")
      assert(page.size > 0)
    end

    test "read a page by uuid", %{uuid: uuid} do
      page = Worker.get_page(uuid)
      assert page.id === uuid  
      assert(page.url == "http://localhost:4001")
      assert(page.size > 0)
    end

    test "parses assets", %{worker: worker} do
      page = Worker.get_page(worker)

      assert length(page.assets) >= 2
      assert Enum.all?(page.assets, fn(asset) ->
        asset.status == :unfetched
      end)
    end

    test "weight resources", %{worker: worker} do
      Process.sleep(2500)
      page = Worker.get_page(worker)

      assert Enum.all?(page.assets, fn(asset) ->
        asset.status == :fetched
      end)



    end



  end



end
