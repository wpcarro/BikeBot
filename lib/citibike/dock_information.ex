defmodule Citibike.DockInformation do
  @moduledoc """
  Module containing functions for working with Citibike Docks.

  """

  alias __MODULE__

  @type t :: %__MODULE__{}

  defstruct [
    :station_id,
    :last_reported,
    :bikes_available,
    :bikes_disabled,
    :docks_available,
    :docks_disabled,
  ]

end
