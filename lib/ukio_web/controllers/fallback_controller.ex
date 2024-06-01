defmodule UkioWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use UkioWeb, :controller

  @errors %{
    not_found: {404, "Resource not found"},
    unavailable: {401, "Apartment not available to book in the specified dates"},
    validation: {400, "Invalid params"}
  }

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: UkioWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  # This clause handles custom errors.
  def call(conn, {:error, error}) do
    {status, message} = Map.get(@errors, error, {400, "Unknown error"})
    render_error(conn, status, message)
  end

  defp render_error(conn, status, message) do
    details = %{custom_message: message}

    conn
    |> put_status(status)
    |> put_view(html: UkioWeb.ErrorHTML, json: UkioWeb.ErrorJSON)
    |> render(:"#{status}", details)
  end
end
