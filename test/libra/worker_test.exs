defmodule Libra.Inspect.WorkerTest do
  use ExUnit.Case

  alias Libra.Inspect.Worker

  describe "fetches a url" do
    test "read a page" do
      {:ok, pid} = Worker.start_link("http://localhost:4001")

      page = Worker.get_page(pid)
      assert(page.url == "http://localhost:4001")
      assert(page.size > 0)
    end
  end
end
