defmodule Ukio.Bookings.Handlers.BookingCreator do
  alias Ukio.Apartments
  alias Ukio.Apartments.Apartment
  alias Ukio.Bookings

  def create(%{"check_in" => nil}), do: {:error, :invalid_date}
  def create(%{"check_out" => nil}), do: {:error, :invalid_date}

  def create(%{
        "check_in" => check_in,
        "check_out" => check_out,
        "apartment_id" => apartment_id
      }) do
    with apartment <- Apartments.get_apartment!(apartment_id),
         {:available, true} <-
           {:available, Apartments.available?(apartment, check_in, check_out)},
         booking <- generate_booking_data(apartment, check_in, check_out) do
      Bookings.create_booking(booking)
    else
      {:available, false} ->
        {:error, :unavailable}

      e ->
        e
    end
  end

  defp generate_booking_data(apartment, check_in, check_out) do
    {utilities, deposit} = Apartment.calculate_costs(apartment)

    %{
      apartment_id: apartment.id,
      check_in: check_in,
      check_out: check_out,
      monthly_rent: apartment.monthly_price,
      utilities: utilities,
      deposit: deposit
    }
  end
end
