defmodule Citibike.StationInformation do
  @moduledoc """
  Module responsible for downloading the Station Information feed.

  """

  alias __MODULE__

  @type t :: %__MODULE__{}

  defstruct [
    :station_id,
    :name,
    :short_name,
    :lat,
    :lon,
    :region_id,
    :rental_methods,
    :capacity,
    :eightd_has_key_dispenser,
  ]

  @url "https://gbfs.citibikenyc.com/gbfs/en/station_information.json"


  @doc """
  Fetches the data from the Citibike Open Data endpoint and decodes it into a `StationInformation.t`

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
  Returns a `Citibike.StationInformation.t` from a station ID.

  """
  @spec from_id(binary) :: t
  def from_id(id) do
    fetch()
    |> Enum.find(& Map.get(&1, :station_id) == id)
  end


  @spec decode(Map.t) :: t
  def decode(raw) do
    %StationInformation{
      station_id: Map.get(raw, "station_id"),
      name: Map.get(raw, "name"),
      short_name: Map.get(raw, "short_name"),
      lat: Map.get(raw, "lat"),
      lon: Map.get(raw, "lon"),
      region_id: Map.get(raw, "region_id"),
      rental_methods: Map.get(raw, "rental_methods"),
      capacity: Map.get(raw, "capacity"),
      eightd_has_key_dispenser: Map.get(raw, "eightd_has_key_dispenser"),
    }
  end
end
