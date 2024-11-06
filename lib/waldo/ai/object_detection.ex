defmodule Waldo.AI.ObjectDetection do
  @moduledoc """
  This module handles the API calls to third-party AI object detection services.
  """

  @api_url "https://demo.api4ai.cloud/general-det/v1/results"

  @doc """
  Sends an image to the third-party AI object detection service for analysis.

  ## Parameters
  - binary_data: The binary data of the image.

  ## Returns
  - {:ok, list_of_objects} on success
  - {:error, reason} on failure
  """
  def detect_objects(binary_data) do
    headers = [
      {"Accept", "application/json"}
    ]

    form_data = [
      image: binary_data,
    ]

    request = Req.new(url: @api_url, headers: headers, method: :post, form_multipart: form_data)

    case Req.post(request) do
      {:ok, %Req.Response{status: 200, body: response_body}} ->
        objects = extract_objects(response_body)
        {:ok, objects}

      {:ok, response} ->
        {:error, "API call failed with status code #{response.status}"}

      {:error, %Req.HTTPError{reason: reason}} ->
        {:error, reason}
    end
  end

  defp extract_objects(%{"results" => results}) do
    results
    |> Enum.flat_map(&extract_entities/1)
    |> Enum.flat_map(&extract_objects_from_entity/1)
    |> Enum.flat_map(&extract_class_labels/1)
  end

  defp extract_objects(_response), do: []

  defp extract_entities(%{"entities" => entities}) do
    Enum.filter(entities, &(&1["kind"] == "objects"))
  end

  defp extract_objects_from_entity(%{"objects" => objects}) do
    objects
  end

  defp extract_class_labels(%{"entities" => entities}) do
    entities
    |> Enum.filter(&(&1["kind"] == "classes"))
    |> Enum.flat_map(&Map.keys(&1["classes"]))
  end
end
