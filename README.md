# Waldo

To start Waldo:

  * Start a docker postgres container (see the Database section of the README
  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

## Database

To set up a docker postgres container for this project in development, run:

```
docker run --name postgres_dev -e POSTGRES_PASSWORD=postgres -e POSTGRES_USER=postgres -e POSTGRES_DB=waldo_dev -p 5432:5432 -d postgres
```

## Interacting with the API

Use curl commands to make API calls.

Get all images:

`curl -X GET "http://localhost:4000/images"`

Get an image by its id:

`curl -X GET "http://localhost:4000/images/{id}"`

Get an image by its detected objects list:

`curl -X GET "http://localhost:4000/images?objects=teddy%20bear,person"`

Upload a new image for object detection:

```
curl -X POST http://localhost:4000/images \
     -H "Content-Type: multipart/form-data" \
     -F "image=@/path/to/your/image.jpg" \
     -F "label=imagelabel"
```
