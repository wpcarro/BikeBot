defmodule Citibike.StationInformationTest do
  use ExUnit.Case, async: true

  alias Citibike.StationInformation

  describe "decode/1" do
    test "works" do
      raw = %{
        "station_id" => "72",
        "capacity" => 39,
        "eightd_has_key_dispenser" => false,
        "lat" => 40.76727216,
        "lon" => -73.99392888,
        "name" => "W 52 St & 11 Ave",
        "region_id" => 71,
        "rental_methods" => ["KEY", "CREDITCARD"],
        "short_name" => "6926.01",
      }

      assert StationInformation.decode(raw) ==
        %StationInformation{
          station_id: "72",
          capacity: 39,
          eightd_has_key_dispenser: false,
          lat: 40.76727216,
          lon: -73.99392888,
          name: "W 52 St & 11 Ave",
          region_id: 71,
          rental_methods: ["KEY", "CREDITCARD"],
          short_name: "6926.01",
        }
    end
  end
end
