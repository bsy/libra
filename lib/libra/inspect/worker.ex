defmodule Libra.Inspect.Worker do
  use GenServer
  alias Libra.Page

  def start_link(url) do
    GenServer.start_link(__MODULE__, url)
  end

  def init(url) do
      page = %Page{url: url}
      {:ok, page}
  end
end
