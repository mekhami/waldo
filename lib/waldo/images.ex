defmodule Waldo.Images do
  @moduledoc """
  The Images context.
  """

  import Ecto.Query, warn: false
  alias Waldo.Repo

  alias Waldo.Images.Image
  alias Waldo.AI.ObjectDetection

  @doc """
  Returns the list of images.

  ## Examples

  iex> list_images()
  [%Image{}, ...]

  """
  def list_images do
    Repo.all(Image)
  end

  @doc """
  Lists all images containing the object requested
  """
  def get_images_by_objects(objects) do
    query = from i in Image,
      where: fragment("? && ?", i.objects, ^objects),
      select: i

    Repo.all(query)
  end

  @doc """
  Gets a single image.

  Raises `Ecto.NoResultsError` if the Image does not exist.

  ## Examples

  iex> get_image!(123)
  %Image{}

  iex> get_image!(456)
  ** (Ecto.NoResultsError)

  """
  def get_image!(id), do: Repo.get!(Image, id)

  @doc """
  Creates a image.

  ## Examples

  iex> create_image(%{field: value})
  {:ok, %Image{}}

  iex> create_image(%{field: bad_value})
  {:error, %Ecto.Changeset{}}

  """
  def create_image(%{"image" => %Plug.Upload{} = upload} = attrs) do
    {:ok, binary} = File.read(upload.path)

    detected_objects = detect_objects(binary)

    attrs = attrs
            |> Map.put("data", binary)
            |> Map.put("objects", detected_objects)

    %Image{}
    |> Image.changeset(attrs)
    |> Repo.insert()
  end


  @doc """
  Detects objects in the given binary image data using a third-party AI service.
  """
  def detect_objects(binary) do
    case ObjectDetection.detect_objects(binary) do
      {:ok, objects} -> objects
      {:error, _reason} -> [] # Default to an empty list if detection fails
    end
  end
end
