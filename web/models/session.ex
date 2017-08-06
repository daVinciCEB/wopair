defmodule WorkoutDemo.Session do
  use WorkoutDemo.Web, :model

  @derive {Poison.Encoder, only: [:token]}
  schema "sessions" do
    field :token, :string
    field :ip_address, :string
    belongs_to :user, WorkoutDemo.User

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:user_id, :ip_address])
    |> validate_required([:user_id, :ip_address])
  end

  def create_changeset(struct, params \\ %{}) do
    struct
    |> changeset(params)
    |> put_change(:token, SecureRandom.urlsafe_base64())
  end

  def get_user_ip_address(conn) do
    # Get the remote IP from the X-Forwarded-For header if present, so this
    # works as expected when behind a load balancer
    remote_ips = Plug.Conn.get_req_header(conn, "x-forwarded-for")
    remote_ip = List.first(remote_ips)

    case remote_ip do
      nil -> 
        # If there was nothing in X-Forarded-For, use the remote IP directly
        # Extract the remote IP from the connection
        remote_ip_as_tuple = conn.remote_ip
        # The remote IP is a tuple like `{127, 0, 0, 1}`, so we need join it into a string
        Enum.join(Tuple.to_list(remote_ip_as_tuple), ".")
      _otherwise ->
        # The remote IP is a tuple like `{127, 0, 0, 1}`, so we need join it into a string
        Enum.join(Tuple.to_list(remote_ip), ".")
    end
  end
end
