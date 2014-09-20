defmodule Repo.Base.Migrations.AddIndexForWordInDictionary do
  use Ecto.Migration

  def up do
    """
    CREATE INDEX "dictionary_word_idx"
    ON dictionary(word);
    """
  end

  def down do
    """
    REMOVE INDEX "dictionary_word_idx";
    """
  end
end
