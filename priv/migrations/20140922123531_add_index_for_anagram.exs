defmodule Repo.Migrations.AddIndexForAnagram do
  use Ecto.Migration

  def up do
    """
    CREATE INDEX dictionary_anagram_idx
    ON dictionary(anagram);
    """
  end

  def down do
    """
    REMOVE INDEX "dictionary_anagram_idx";
    """
  end
end
