defmodule MorsegramTest do
  use ExUnit.Case
  doctest Morsegram

  test "greets the world" do
    assert Morsegram.hello() == :world
  end
end
