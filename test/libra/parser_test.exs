defmodule Libra.ParserTest do
  use ExUnit.Case

  doctest Libra.Parser

  @response File.read!("test/fixtures/github.html")

  setup do
    {:ok, parsed: Libra.Parser.parse_page(@response)}
  end

  test "it returns the page size", %{parsed: parsed} do
    assert parsed.size == 25618
  end

  describe "stylesheets" do
    test "it finds all linked stylesheets", %{parsed: parsed} do
      assert 3 == length(parsed.stylesheets)
    end

    test "it returns the stylesheet href", %{parsed: parsed} do
      [first | _rest] = parsed.stylesheets

      assert first =~ ~r(^http\S+\.css$)
    end
  end

  describe "scripts" do
    test "it finds all script references", %{parsed: parsed} do
      assert 3 == length(parsed.scripts)
    end

    test "it returns the script src", %{parsed: parsed} do
      [first | _rest] = parsed.scripts

      assert first =~ ~r(^http\S+\.js$)
    end
  end
end
