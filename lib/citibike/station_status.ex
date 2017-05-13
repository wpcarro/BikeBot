defmodule Citibike.StationStatus do
  @moduledoc """
  Module responsible for downloading the Station Information feed.

  """

  alias Citibike.DockInformation
  alias __MODULE__

  @type t :: %__MODULE__{}

  defstruct [
    :station_id,
    :num_bikes_available,
    :num_bikes_disabled,
    :num_docks_available,
    :num_docks_disabled,
    :is_installed,
    :is_renting,
    :is_returning,
    :last_reported,
    :eightd_has_available_keys,
  ]

  @url "https://gbfs.citibikenyc.com/gbfs/en/station_status.json"
  @citibike_date_fmt "{s-epoch}"


  @doc """
  Fetches the data from the Citibike Open Data endpoint and decodes it into a `StationStatus.t`

  """
  @spec fetch(keyword) :: [Map.t]
  def fetch(opts \\ []) do
    HTTPoison.get!(@url, opts)
    |> Map.get(:body)
    |> Poison.decode!()
    |> get_in(["data", "stations"])
    |> Stream.map(&decode/1)
    |> Enum.into([])
  end


  @doc """
  Returns a `Citibike.StationStatus.t` from a station ID.

  """
  @spec from_id(binary) :: t
  def from_id(id) do
    fetch()
    |> Enum.find(& Map.get(&1, :station_id) == id)
  end


  @doc """
  Decodes individual records.

  """
  @spec decode(Map.t) :: t
  def decode(raw) do
    %StationStatus{
      station_id: Map.get(raw, "station_id"),
      num_bikes_available: Map.get(raw, "num_bikes_available"),
      num_bikes_disabled: Map.get(raw, "num_bikes_disabled"),
      num_docks_available: Map.get(raw, "num_docks_available"),
      num_docks_disabled: Map.get(raw, "num_docks_disabled"),
      is_installed: Map.get(raw, "is_installed"),
      is_renting: Map.get(raw, "is_renting"),
      is_returning: Map.get(raw, "is_returning"),
      last_reported: Map.get(raw, "last_reported") |> to_string |> Timex.parse!(@citibike_date_fmt),
      eightd_has_available_keys: Map.get(raw, "eightd_has_available_keys"),
    }
  end


  @spec dock_information(t) :: DockInformation.t
  def dock_information(station_status) do
    %DockInformation{
      station_id: station_status.station_id,
      last_reported: station_status.last_reported,
      bikes_available: station_status.num_bikes_available,
      bikes_disabled: station_status.num_bikes_disabled,
      docks_available: station_status.num_docks_available,
      docks_disabled: station_status.num_docks_disabled,
    }
  end
end
