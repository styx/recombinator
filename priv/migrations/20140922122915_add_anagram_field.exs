defmodule Repo.Migrations.AddAnagramField do
  use Ecto.Migration

  def up do
    """
    ALTER TABLE dictionary
    ADD COLUMN anagram VARCHAR(70),
    ALTER COLUMN anagram SET DEFAULT '_';
    """
  end

  def down do
    """
    ALTER TABLE dictionary
    REMOVE COLUMN anagram VARCHAR(70) NOT NULL;
    """
  end
end
