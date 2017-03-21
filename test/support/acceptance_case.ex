defmodule Libra.AcceptanceCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Wallaby.DSL

      alias Libra.Repo
      import Ecto
      import Ecto.Changeset
      import Ecto.Query

      import Libra.Router.Helpers

      # The default endpoint for testing
      @endpoint Libra.Endpoint
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Libra.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Libra.Repo, {:shared, self()})
    end

    metadata = Phoenix.Ecto.SQL.Sandbox.metadata_for(Libra.Repo, self())
    {:ok, session} = Wallaby.start_session(metadata: metadata)
    {:ok, session: session}
  end
end
