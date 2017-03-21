defmodule Libra.Repo.Migrations.CreatePage do
  use Ecto.Migration

  def up do
    execute "CREATE TYPE asset_status AS ENUM ('unfetched','fetched', 'failed')"

    create table(:pages, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :url, :string
      add :size, :integer
      add :assets, {:array, :map}, default: []

      timestamps()
    end
  end

  def down do
    drop table(:pages)

    execute "DROP TYPE asset_status"
  end
end
