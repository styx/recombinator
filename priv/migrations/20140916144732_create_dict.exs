defmodule Repo.CreateDictionary do
  use Ecto.Migration

  def up do
    """
    CREATE TABLE "dictionary" (
      id        SERIAL PRIMARY KEY,
      word      VARCHAR(70) NOT NULL,
      info      TEXT
    );
    """
  end

  def down do
    """
    DROP TABLE "dictionary";
    """
  end
end
