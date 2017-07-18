use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :workout_demo, WorkoutDemo.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
config :workout_demo, WorkoutDemo.Repo,
  adapter: Ecto.Adapters.Postgres,
  types: WorkoutDemo.PostgresTypes,
  username: "postgres",
  password: "postgres",
  database: "workout_demo_test",
  hostname: if(System.get_env("CI"), do: "mdillon__postgis", else: "localhost"),
  # hostname: "mdillon__postgis",
  pool: Ecto.Adapters.SQL.Sandbox
