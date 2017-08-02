use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :workout_demo, WorkoutDemo.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Lower the encryption on comeonin for testing purposes
config :comeonin, :bcrypt_log_rounds, 4
config :comeonin, :pbkdf2_rounds, 1

# Configure your database
config :workout_demo, WorkoutDemo.Repo,
  adapter: Ecto.Adapters.Postgres,
  types: WorkoutDemo.PostgresTypes,
  username: "postgres",
  password: "postgres",
  database: "workout_demo_test",
  hostname: if(System.get_env("CI"), do: "mdillon__postgis", else: "localhost"),
  pool: Ecto.Adapters.SQL.Sandbox

config :workout_demo, WorkoutDemo.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "smtp.mailgun.org",
  port: 587,
  username: "postmaster@sandboxf7a47eedde5849538460545a3035c9a6.mailgun.org",
  password: "a7183c32664ba8130eff1a0549a99729",
  tls: :if_available, # can be `:always` or `:never`
  ssl: false, # can be `true`
  retries: 1