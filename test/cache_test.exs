defmodule CacheTest do
  use ExUnit.Case

  test "initial map is empty" do
    {:ok, pid} = Cache.start_link()

    assert %{} == Cache.read(pid)
  end

  test "adding item to the map changes the state" do
    {:ok, pid} = Cache.start_link()

    Cache.write(pid, :stooges, ["Larry", "Curly", "Moe"])

    assert ["Larry", "Curly", "Moe"] == Cache.read(pid, :stooges)
  end

  test "deleting item removes item from the map" do
    {:ok, pid} = Cache.start_link()

    Cache.delete(pid, :stooges)

    assert %{} == Cache.read(pid)
  end

  test "return true if item is in the state" do
    {:ok, pid} = Cache.start_link()

    Cache.write(pid, :stooges, ["Larry", "Curly", "Moe"])

    assert true == Cache.exists?(pid, :stooges)
  end

  test "return false if item is not present in the state" do
    {:ok, pid} = Cache.start_link()

    assert false == Cache.exists?(pid, :stooges)
  end

  test "remove all items" do
    {:ok, pid} = Cache.start_link()

    Cache.write(pid, :stooges, ["Larry", "Curly", "Moe"])
    Cache.clear(pid)

    assert %{} == Cache.read(pid)
  end
end
