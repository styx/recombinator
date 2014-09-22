defmodule Dictionary do
  use Ecto.Model

  schema "dictionary" do
    field :word,    :string
    field :info,    :string
    field :anagram, :string
  end

end
