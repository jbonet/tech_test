defmodule UkioWeb.BookingController do
  use UkioWeb, :controller

  alias Ukio.Bookings
  alias Ukio.Bookings.Booking
  alias Ukio.Bookings.Handlers.BookingCreator

  action_fallback UkioWeb.FallbackController

  def create(conn, %{"booking" => booking_params}) do
    # The controller should validate params and reject invalid requests.
    # For convenience in this exercise, I am delegating this to the handler.
    with {:ok, %Booking{} = booking} <- BookingCreator.create(booking_params) do
      conn
      |> put_status(:created)
      |> render(:show, booking: booking)
    else
      {:error, :invalid_date} -> {:error, :validation}
      e -> e
    end
  end

  def show(conn, %{"id" => id}) do
    booking = Bookings.get_booking!(id)
    render(conn, :show, booking: booking)
  end
end
