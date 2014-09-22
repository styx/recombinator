defmodule Repo.Migrations.AddRemoveDefaultForAnagram do
  use Ecto.Migration

  def up do
    """
    ALTER TABLE dictionary
    ALTER COLUMN anagram DROP DEFAULT;
    """
  end

  def down do
    """
    ALTER TABLE dictionary
    ALTER COLUMN anagram SET DEFAULT '_';
    """
  end
end
