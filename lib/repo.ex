defmodule Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres

  def conf do
    parse_url Application.get_env(:recombinate, :db_path)
  end

  def priv do
    app_dir(:recombinate, "priv")
  end
end
