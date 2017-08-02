defmodule WorkoutDemo.VerificationEmail do
  use Bamboo.Phoenix, view: WorkoutDemo.EmailView

  import Bamboo.Email

  @doc """
    The sign in email containing the verification link.
  """
  def verification_email(token_value, user) do
    new_email()
    |> to(user.email)
    |> from("coby.benveniste@gmail.com")
    |> subject("Please Verify Your WoM Account")
    |> html_body("<strong>Welcome to WoM!</strong><br /><p>Please verify your account <a href=http://localhost:4000/verify/" <> token_value <> ">here</a> </p>")
  end
end