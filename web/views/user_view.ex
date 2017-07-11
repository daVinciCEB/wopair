defmodule WorkoutDemo.UserView do
  use WorkoutDemo.Web, :view

  def render("index.json", %{users: users}) do
    %{data: render_many(users, WorkoutDemo.UserView, "user.json")}
  end

  def render("show.json", %{user: user}) do
    %{data: render_one(user, WorkoutDemo.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      name: user.name,
      email: user.email,
      password_hash: user.password_hash,
      description: user.description,
      location: user.location}
  end
end
