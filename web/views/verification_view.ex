defmodule WorkoutDemo.VerificationView do
  use WorkoutDemo.Web, :view

  def render("show.json", %{user: user}) do
    %{user: render_one(user, WorkoutDemo.UserView, "user_verified.json")}
  end
end
