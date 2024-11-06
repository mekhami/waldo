defmodule Waldo.ImagesTest do
  use Waldo.DataCase

  alias Waldo.Images

  describe "images" do
    alias Waldo.Images.Image

    import Waldo.ImagesFixtures

    @invalid_attrs %{label: nil, file_path: nil, objects: nil}

    test "list_images/0 returns all images" do
      image = image_fixture()
      assert Images.list_images() == [image]
    end

    test "get_image!/1 returns the image with given id" do
      image = image_fixture()
      assert Images.get_image!(image.id) == image
    end

    test "create_image/1 with valid data creates a image" do
      valid_attrs = %{label: "some label", file_path: "some file_path", objects: ["option1", "option2"]}

      assert {:ok, %Image{} = image} = Images.create_image(valid_attrs)
      assert image.label == "some label"
      assert image.file_path == "some file_path"
      assert image.objects == ["option1", "option2"]
    end

    test "create_image/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Images.create_image(@invalid_attrs)
    end

    test "update_image/2 with valid data updates the image" do
      image = image_fixture()
      update_attrs = %{label: "some updated label", file_path: "some updated file_path", objects: ["option1"]}

      assert {:ok, %Image{} = image} = Images.update_image(image, update_attrs)
      assert image.label == "some updated label"
      assert image.file_path == "some updated file_path"
      assert image.objects == ["option1"]
    end

    test "update_image/2 with invalid data returns error changeset" do
      image = image_fixture()
      assert {:error, %Ecto.Changeset{}} = Images.update_image(image, @invalid_attrs)
      assert image == Images.get_image!(image.id)
    end

    test "delete_image/1 deletes the image" do
      image = image_fixture()
      assert {:ok, %Image{}} = Images.delete_image(image)
      assert_raise Ecto.NoResultsError, fn -> Images.get_image!(image.id) end
    end

    test "change_image/1 returns a image changeset" do
      image = image_fixture()
      assert %Ecto.Changeset{} = Images.change_image(image)
    end
  end
end
