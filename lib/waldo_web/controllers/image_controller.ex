defmodule WaldoWeb.ImageController do
  use WaldoWeb, :controller

  alias Waldo.Images

  def index(conn, _params) do
    images = Images.list_images()

    json(conn, Enum.map(images, &format_to_json/1))
  end

  def create(conn, attrs) do
    case Images.create_image(attrs) do
      {:ok, image} ->
        conn
        |> put_status(:created)
        |> json(format_to_json(image))

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> json(%{errors: changeset})
    end
  end

  def show(conn, %{"id" => id}) do
    case Images.get_image!(id) do
      nil ->
        conn
        |> send_resp(:not_found, "Image not found")

      %Images.Image{} = image ->
        json(conn, format_to_json(image))
    end
  end

  def filter_by_objects(conn, %{"objects" => objects}) do
    objects_list = String.split(objects, ",")
    images = Images.get_images_by_objects(objects_list)
    json(conn, Enum.map(images, &format_to_json/1))
  end

  defp format_to_json(image) do
    %{
      id: image.id,
      label: image.label,
      objects: image.objects,
      inserted_at: image.inserted_at,
      updated_at: image.updated_at
    }
  end
end
