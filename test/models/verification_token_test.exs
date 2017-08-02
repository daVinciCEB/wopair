defmodule WorkoutDemo.VerificationTokenTest do
  use WorkoutDemo.ModelCase

  alias WorkoutDemo.VerificationToken

  @valid_attrs %{token: "1234567890", user_id: 12345}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = VerificationToken.changeset(%VerificationToken{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = VerificationToken.changeset(%VerificationToken{}, @invalid_attrs)
    refute changeset.valid?
  end
end
