defmodule Forum.Repo.Migrations.AddHashPassword do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :hash_password, :string
    end
  end
end
