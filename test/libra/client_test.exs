defmodule Libra.ClientTest do
  use ExUnit.Case

  describe "fetch_page/1" do
    test "it fetches and parses a page" do
      url = "http://localhost:4001"

      assert {:ok, %Libra.Parser.Result{}} =
        Libra.Client.fetch_page(url)
    end

    test "it returns an error if url invalid" do
      url = "http://localhost:4002"

      assert {:error, _} = Libra.Client.fetch_page(url)
    end
  end

  describe "weigh_resource/1" do
    test "it fetches and parses a page" do
      url = "http://localhost:4001"

      assert {:ok, 1156} == Libra.Client.weigh_resource(url)
    end

    test "it returns an error if url invalid" do
      url = "http://localhost:4002"

      assert {:error, _} = Libra.Client.weigh_resource(url)
    end
  end
end
