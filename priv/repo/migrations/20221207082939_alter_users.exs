defmodule Movies.Repo.Migrations.AlterUsers do
  use Ecto.Migration

  def change do
    create table(:movies) do
      add :movie_id, :string
      add :name, :string
      add :user_id, references(:users)
end
end
end
