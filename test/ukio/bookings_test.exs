defmodule Ukio.BookingsTest do
  use Ukio.DataCase

  alias Ukio.Bookings

  describe "bookings" do
    alias Ukio.Bookings.Booking
    alias Ukio.Bookings.Handlers.BookingCreator

    import Ukio.ApartmentsFixtures
    import Ukio.BookingsFixtures

    @invalid_attrs %{
      apartment_id: nil,
      check_in: nil,
      check_out: nil,
      deposit: nil,
      monthly_rent: nil,
      utilities: nil
    }
    setup do
      %{apartment: apartment_fixture()}
    end

    test "list_bookings/0 returns all bookings" do
      booking = booking_fixture()
      assert Bookings.list_bookings() == [booking]
    end

    test "get_booking!/1 returns the booking with given id" do
      booking = booking_fixture()
      assert Bookings.get_booking!(booking.id) == booking
    end

    test "create_booking/1 with valid data creates a booking", %{apartment: apartment} do
      valid_attrs = %{
        apartment_id: apartment.id,
        check_in: ~D[2023-03-26],
        check_out: ~D[2023-03-26],
        deposit: 100_000,
        monthly_rent: 250_000,
        utilities: 20000
      }

      assert {:ok, %Booking{} = booking} = Bookings.create_booking(valid_attrs)
      assert booking.apartment_id == apartment.id
      assert booking.check_in == ~D[2023-03-26]
      assert booking.check_out == ~D[2023-03-26]
      assert booking.deposit == 100_000
      assert booking.monthly_rent == 250_000
      assert booking.utilities == 20000
    end

    test "create_booking/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Bookings.create_booking(@invalid_attrs)
    end

    test "update_booking/2 with valid data updates the booking" do
      booking = booking_fixture()

      update_attrs = %{
        check_in: ~D[2023-03-27],
        check_out: ~D[2023-03-27]
      }

      assert {:ok, %Booking{} = booking} = Bookings.update_booking(booking, update_attrs)
      assert booking.check_in == ~D[2023-03-27]
      assert booking.check_out == ~D[2023-03-27]
    end

    test "update_booking/2 with invalid data returns error changeset" do
      booking = booking_fixture()
      assert {:error, %Ecto.Changeset{}} = Bookings.update_booking(booking, @invalid_attrs)
      assert booking == Bookings.get_booking!(booking.id)
    end

    test "delete_booking/1 deletes the booking" do
      booking = booking_fixture()
      assert {:ok, %Booking{}} = Bookings.delete_booking(booking)
      assert_raise Ecto.NoResultsError, fn -> Bookings.get_booking!(booking.id) end
    end

    test "change_booking/1 returns a booking changeset" do
      booking = booking_fixture()
      assert %Ecto.Changeset{} = Bookings.change_booking(booking)
    end

    test "booking an apartment from 'Mars' has specific rates" do
      apartment = apartment_fixture(%{market: "Mars", monthly_price: 250_000, square_meters: 60})

      booking_params = %{
        "check_in" => ~D[2023-03-26],
        "check_out" => ~D[2023-03-27],
        "apartment_id" => apartment.id
      }

      {:ok, booking} = BookingCreator.create(booking_params)

      assert booking.deposit == 250_000
      assert booking.utilities == 600
    end

    test "booking an already booked apartment should fail" do
      booking = booking_fixture(%{check_in: ~D[2024-05-26], check_out: ~D[2024-06-26]})

      booking_params = %{
        "check_in" => ~D[2024-05-30],
        "check_out" => ~D[2023-06-29],
        "apartment_id" => booking.apartment_id
      }

      assert {:error, :unavailable} = BookingCreator.create(booking_params)
    end
  end
end
