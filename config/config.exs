# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :ddt, DdtWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "xqaABBUj3wTV9jwZwNymdMtAbPULI5VAsSwEp1/TG0dFzZ19mM7eK9rrIKyd5aPK",
  render_errors: [view: DdtWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Ddt.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ex_statsd,
       host: "localhost",
       port: 1234, # default is 8125
       namespace: "hub",
       tags: ["server:h01"]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
