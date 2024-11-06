defmodule Waldo.ImagesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Waldo.Images` context.
  """

  @doc """
  Generate a image.
  """
  def image_fixture(attrs \\ %{}) do
    {:ok, image} =
      attrs
      |> Enum.into(%{
        file_path: "some file_path",
        label: "some label",
        objects: ["option1", "option2"]
      })
      |> Waldo.Images.create_image()

    image
  end
end
