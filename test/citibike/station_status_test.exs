defmodule Citibike.StationStatusTest do
  use ExUnit.Case, async: true

  alias Citibike.StationStatus

  describe "decode/1" do
    test "works" do
      raw = %{
        "station_id" => "3462",
        "num_bikes_available" => 2,
        "num_bikes_disabled" => 1,
        "num_docks_available" => 36,
        "num_docks_disabled" => 0,
        "is_installed" => 1,
        "is_renting" => 1,
        "is_returning" => 1,
        "last_reported" => 1494666161,
        "eightd_has_available_keys" => false
      }

      assert StationStatus.decode(raw) ==
        %StationStatus{
          station_id: "3462",
          num_bikes_available: 2,
          num_bikes_disabled: 1,
          num_docks_available: 36,
          num_docks_disabled: 0,
          is_installed: 1,
          is_renting: 1,
          is_returning: 1,
          last_reported: Timex.parse!("1494666161", "{s-epoch}"),
          eightd_has_available_keys: false
        }
    end
  end
end
