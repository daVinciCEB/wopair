defmodule WorkoutDemo.VerificationEmail do
  use Bamboo.Phoenix, view: WorkoutDemo.EmailView

  import Bamboo.Email

  @doc """
    The sign in email containing the verification link.
  """
  def verification_email(token_value, user) do
    new_email()
    |> to(user.email)
    |> from("verify@wopair.com")
    |> subject("Please Verify Your WoPair Account")
    |> html_body("<strong>Welcome to WoPair!</strong><br /><p>Please verify your account <a href=http://api.wopair.com/api/verify/" <> token_value <> ">here</a> </p>")
  end
end