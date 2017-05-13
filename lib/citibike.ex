defmodule Citibike do
  @moduledoc """
  Top-level module that exposes the following data sources:

  ## Sources

    * Station Information
    * Station Status

  """

  alias Citibike.{StationInformation, StationStatus}


  @doc """
  Fetches the Citibike Station Information data.

  """
  defdelegate station_information(), to: StationInformation, as: :fetch


  @doc """
  Fetches the Citibike Station Information data.

  """
  defdelegate station_status(), to: StationStatus, as: :fetch


  @doc """
  Outputs dock information for a station.

  """
  defdelegate dock_information(station_status), to: StationStatus

end
