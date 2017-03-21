defmodule Libra.UserInspectsPage do
  use Libra.AcceptanceCase, async: false

  test "it inspects a page", %{session: session} do
    session
    |> visit("/")
    |> fill_in("Page url", with: "http://localhost:4001")
    |> click_on("Start!")

    title = find(session, "main > h2") |> text
    stylesheets_tr = find(session, ".stylesheets tbody tr")
                     |> text
    scripts_tr = find(session, ".scripts tbody tr")
                 |> text

    assert title == "Results for http://localhost:4001"
    assert stylesheets_tr =~ ~r/^http:\/\/localhost:4001\/css\/app.css fetched \d+(\.{1}\d+)? KB$/
    assert scripts_tr =~ ~r/^http:\/\/localhost:4001\/js\/app.js fetched \d+(\.{1}\d+)? KB$/
  end
end
