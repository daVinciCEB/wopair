defmodule WorkoutDemo.SessionView do
  use WorkoutDemo.Web, :view

  def render("show.json", %{session: session}) do
    %{session: render_one(session, WorkoutDemo.SessionView, "session.json")}
  end

  def render("session.json", %{session: session}) do
    %{token: session.token}
  end

  def render("error_1.json", _anything) do
    %{errors1: "failed to authenticate"}
  end
  def render("error_2.json", _anything) do
    %{errors2: "failed to authenticate"}
  end
  def render("index.json", %{user: user}) do
    %{user: user.email}
  end
end