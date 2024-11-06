defmodule Waldo.Images.Image do
  use Ecto.Schema
  import Ecto.Changeset

  schema "images" do
    field :label, :string
    field :data, :binary
    field :objects, {:array, :string}

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, [:data, :label, :objects])
    |> validate_required([:data])
  end
end
