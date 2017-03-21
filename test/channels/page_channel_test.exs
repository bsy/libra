defmodule Libra.PageChannelTest do
  use Libra.ChannelCase

  alias Libra.{Page, PageChannel, PageView, Repo, Endpoint}

  describe "existing page" do
    setup do
      page = Page.changeset(%Page{}, %{url: "http://localhost:4001"})
             |> Repo.insert!
      {:ok, page: page}
    end

    test "it opens the channel", %{page: page} do
      assert {:ok, _, _socket} =
        socket(nil, %{})
        |> subscribe_and_join(PageChannel, "page:" <> page.id)
    end

    test "it handles page updates", %{page: page} do
      {:ok, _, _socket} = socket(nil, %{})
                         |> subscribe_and_join(PageChannel, "page:" <> page.id)

      Endpoint.broadcast("page:" <> page.id, "page-update", page)

      expected_payload = Phoenix.View.render_to_string(PageView,
                                                       "page.html",
                                                       %{page: page})

      assert_push "page-update", %{results: ^expected_payload}
    end
  end

  describe "non-existing page" do
    test "it closes the socket" do
      uuid = Ecto.UUID.generate

      assert {:error, %{reason: "page not found"}} ==
        socket(nil, %{})
        |> subscribe_and_join(PageChannel, "page:" <> uuid)
    end
  end
end
