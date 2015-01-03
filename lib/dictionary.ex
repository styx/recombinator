defmodule Dictionary do
  use Ecto.Model

  schema "dictionary" do
    field :word,    :string
    field :info,    :string
    field :anagram, :string
  end
end

defimpl String.Chars, for: Dictionary do
  def to_string(word) do
    word.word
  end
end
