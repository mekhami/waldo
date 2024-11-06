defmodule Waldo.Repo do
  use Ecto.Repo,
    otp_app: :waldo,
    adapter: Ecto.Adapters.Postgres
end
