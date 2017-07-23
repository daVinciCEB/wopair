defmodule WorkoutDemo.SessionView do
  use WorkoutDemo.Web, :view

  def render("show.json", %{session: session}) do
    %{session: render_one(session, WorkoutDemo.SessionView, "session.json")}
  end

  def render("session.json", %{session: session}) do
    %{token: session.token}
  end

  def render("error.json", _anything) do
    %{errors1: "failed to authenticate"}
  end
end