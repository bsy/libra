defmodule Libra.Parser.Result do
  @moduledoc """
  Represents the result of a parse operation.

  It includes data about the page, plus all references to external resources
  """
  defstruct size: 0,
            stylesheets: [],
            scripts: []

  @type t :: %__MODULE__{
    size: non_neg_integer,
    stylesheets: [String.t],
    scripts: [String.t]
  }
end
