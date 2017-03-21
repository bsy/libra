ExUnit.start

Ecto.Adapters.SQL.Sandbox.mode(Libra.Repo, :manual)

Application.put_env(:wallaby, :base_url, Libra.Endpoint.url)
{:ok, _} = Application.ensure_all_started(:wallaby)
