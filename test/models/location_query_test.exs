defmodule WorkoutDemo.LocationQueryTest do
  use WorkoutDemo.ModelCase

  alias WorkoutDemo.LocationQuery

  @valid_attrs %{latitude: 76.5, longitude: 120.5, radius: 1000}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = LocationQuery.changeset(%LocationQuery{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = LocationQuery.changeset(%LocationQuery{}, @invalid_attrs)
    refute changeset.valid?
  end
end
