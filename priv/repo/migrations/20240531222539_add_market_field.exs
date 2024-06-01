defmodule Ukio.Repo.Migrations.AddMarketField do
  use Ecto.Migration

  def change do
    alter table(:apartments) do
      add :market, :string
    end
  end
end
