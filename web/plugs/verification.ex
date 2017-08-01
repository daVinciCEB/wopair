defmodule WorkoutDemo.Verification do
  import Plug.Conn
  require Logger

  def init(options), do: options

  def call(conn, _opts) do
    case verify_user(conn) do
      :ok -> conn
      _otherwise  -> verification_error!(conn)
    end
  end

  defp verify_user(conn) do
    user = conn.assigns.current_user
    case user.verified do
      true -> :ok
      _otherwise -> :error
    end
  end

  defp verification_error!(conn) do
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(:unauthorized, "{ \"error\": \"Verify Your User\"}") |> halt()
  end
end