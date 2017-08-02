use Mix.Config

# For development, we disable any cache and enable
# debugging and code reloading.
#
# The watchers configuration can be used to run external
# watchers to your application. For example, we use it
# with brunch.io to recompile .js and .css sources.
config :workout_demo, WorkoutDemo.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: []


# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Configure your database
config :workout_demo, WorkoutDemo.Repo,
  adapter: Ecto.Adapters.Postgres,
  types: WorkoutDemo.PostgresTypes,
  username: "postgres",
  password: "postgres",
  database: "workout_demo_dev",
  hostname: "localhost",
  pool_size: 10

config :workout_demo, WorkoutDemo.Mailer,
  adapter: Bamboo.SMTPAdapter,
  server: "smtp.mailgun.org",
  port: 587,
  username: "postmaster@sandboxf7a47eedde5849538460545a3035c9a6.mailgun.org",
  password: "a7183c32664ba8130eff1a0549a99729",
  tls: :if_available, # can be `:always` or `:never`
  ssl: false, # can be `true`
  retries: 1