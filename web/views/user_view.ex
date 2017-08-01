defmodule WorkoutDemo.UserView do
  use WorkoutDemo.Web, :view

  # def render("index.json", %{users: users}) do
  #   %{users: render_many(users, WorkoutDemo.UserView, "user.json")}
  # end

  def render("show.json", %{user: user}) do
    %{user: render_one(user, WorkoutDemo.UserView, "user.json")}
  end

  def render("user.json", %{user: user}) do
    %{id: user.id,
      name: user.name,
      email: user.email,
      description: user.description}
  end

  def render("user_verified.json", %{user: user}) do
    %{id: user.id,
      name: user.name,
      email: user.email,
      verified: user.verified,
      description: user.description}
  end
end
