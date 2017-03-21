defmodule Libra.PageControllerTest do
  use Libra.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Inspect a new page"
  end

  describe "POST /pages" do
    test "valid url", %{conn: conn} do
      conn = post(conn, "/pages", %{"page_url" => "http://localhost:4001"})
      assert html_response(conn, 302) =~ "redirected"
    end

    test "invalid url", %{conn: conn} do
      conn = post(conn, "/pages", %{"page_url" => "http://localhost:4002"})
      assert html_response(conn, 406) =~ "Error with url: http://localhost:4002"
    end
  end

  describe "GET /pages/:id" do
    test "existing id", %{conn: conn} do
      {:ok, page} = Repo.insert(%Libra.Page{url: "http://localhost:4001"})

      conn = get(conn, "/pages/#{page.id}")
      assert html_response(conn, 200) =~ "Results for http://localhost:4001"
    end

    test "non-existing id", %{conn: conn} do
      uuid = Ecto.UUID.generate()

      assert_error_sent 404, fn ->
        get(conn, "/pages/#{uuid}")
      end
    end
  end
end
