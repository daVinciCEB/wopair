defmodule WorkoutDemo.RegistrationView do
  use WorkoutDemo.Web, :view

  def render("show.json", %{user: user}) do
    %{user: render_one(user, WorkoutDemo.UserView, "user.json")}
  end
end