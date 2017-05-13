defmodule Citibike.Station do
  @moduledoc """
  Module defining a domain-specific Citibike station.

  """

  alias __MODULE__
  alias Citibike.{StationInformation, StationStatus}

  @type t :: %__MODULE__{}

  @type street_opts :: [
    avenue: String.t,
    street: String.t,
  ]

  defstruct [
    :station_id,
    :name,
    :lat,
    :lon,
    :region_id,
    :bikes_available,
    :docks_available,
  ]


  ###################################################################################
  # Public Helpers
  ###################################################################################

  @doc """
  Returns a `Station.t` from a station ID.

  """
  @spec from_id(binary) :: t
  def from_id(id) do
    station_information =
      StationInformation.from_id(id)

    from_station_information(station_information)
  end


  @doc """
  Returns a `Station.t` from an input name.

  """
  @spec from_name(binary) :: [t]
  def from_name(name) do
    Citibike.station_information()
    |> Stream.filter(& String.contains?(String.downcase(&1.name), String.downcase(name)))
    |> Stream.map(& Map.get(&1, :station_id))
    |> Stream.map(&from_id/1)
    |> Enum.into([])
  end


  @doc """
  Returns a `Station.t` from input cross-streets.

  """
  @spec from_cross_streets(street_opts) :: t
  def from_cross_streets(input) do
    input
    |> format_cross_streets()
    |> from_name()
    |> hd()
  end


  ###################################################################################
  # Private Helpers
  ###################################################################################

  @spec format_cross_streets(street_opts) :: String.t
  defp format_cross_streets(avenue: avenue, street: street) do
    "#{street} St & Avenue #{avenue}"
  end


  @spec from_station_information(StationInformation.t) :: t
  defp from_station_information(station_information) do
    station_status =
      StationStatus.from_id(station_information.station_id)

    %Station{
      station_id: station_information.station_id,
      name: station_information.name,
      lat: station_information.lat,
      lon: station_information.lon,
      region_id: station_information.region_id,
      bikes_available: station_status.num_bikes_available,
      docks_available: station_status.num_docks_available,
    }
  end
end
