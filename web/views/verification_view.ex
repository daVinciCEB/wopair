defmodule WorkoutDemo.VerificationView do
  use WorkoutDemo.Web, :view

  def render("show.json", %{session: session}) do
    %{session: render_one(session, WorkoutDemo.SessionView, "session.json")}
  end
end
