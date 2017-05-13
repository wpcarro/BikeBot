defmodule CitibikeTest do
  use ExUnit.Case
  doctest Citibike

  alias Citibike.DockInformation

  test "dock_information/1" do
    time =
      Timex.now()

    dock =
      %Citibike.StationStatus{
        eightd_has_available_keys: false,
        is_installed: 1,
        is_renting: 1,
        is_returning: 1,
        last_reported: time,
        num_bikes_available: 36,
        num_bikes_disabled: 1,
        num_docks_available: 5,
        num_docks_disabled: 0,
        station_id: "445"
      }

    assert Citibike.dock_information(dock) ==
      %DockInformation{
        station_id: "445",
        last_reported: time,
        bikes_available: 36,
        bikes_disabled: 1,
        docks_available: 5,
        docks_disabled: 0,
      }
  end

end
