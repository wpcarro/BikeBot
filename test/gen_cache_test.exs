defmodule Citibike.GenCacheTest do
  use ExUnit.Case

  alias Citibike.GenCache


  describe "push/2" do
    setup do
      GenCache.start_link(max_items: 3)

      on_exit fn ->
        GenCache.empty()
      end

      {:ok, %{}}
    end

    test "pushes an item onto the empty cache" do
      assert GenCache.items() == []

      GenCache.push("a", 12)

      assert GenCache.items() == [{"a", 12}]
    end

    test "pushes an item onto the full cache" do
      assert GenCache.items() == []

      # Full cache
      GenCache.push("a", 1)
      GenCache.push("b", 2)
      GenCache.push("c", 3)

      # Push another...
      GenCache.push("d", 4)

      assert GenCache.items() ==
        [{"d", 4},
         {"c", 3},
         {"b", 2},
        ]

      # Push another...
      GenCache.push("e", 5)

      assert GenCache.items() ==
        [{"e", 5},
         {"d", 4},
         {"c", 3},
        ]
    end
  end

  describe "touch/1" do
    test "re-heats an item from the cache" do
      GenCache.push("a", 1)
      GenCache.push("b", 2)
      GenCache.push("c", 3)

      assert GenCache.items() ==
        [{"c", 3},
         {"b", 2},
         {"a", 1},
        ]

      # Touch an item
      GenCache.touch("a")

      assert GenCache.items() ==
        [{"a", 1},
         {"c", 3},
         {"b", 2},
        ]
    end
  end


  describe "get/1" do
    test "retrieves an item if it's in the cache" do
      GenCache.push("a", 1)

      assert GenCache.get("a") == 1
    end

    test "returns nil if the item is not in the cache" do
      assert GenCache.get("a") == nil
    end
  end


  describe "full?/1" do
    setup do
      GenCache.start_link(max_items: 3)

      on_exit fn ->
        GenCache.empty()
      end

      {:ok, nil}
    end

    test "returns true when the cache is full (max_items)" do
      GenCache.push("a", 1)
      GenCache.push("b", 2)
      GenCache.push("c", 3)

      assert GenCache.full?()
    end

    test "returns false when the cache is not full (max_items)" do
      GenCache.push("a", 1)
      GenCache.push("b", 2)

      assert GenCache.full?()
    end
  end

end
