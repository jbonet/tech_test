defmodule UkioWeb.BookingControllerTest do
  use UkioWeb.ConnCase, async: true

  import Ukio.ApartmentsFixtures, only: [apartment_fixture: 0]
  import Ukio.BookingsFixtures

  @create_attrs %{
    apartment_id: 42,
    check_in: ~D[2023-03-26],
    check_out: ~D[2023-03-26]
  }

  @invalid_attrs %{
    apartment_id: 1,
    check_in: nil,
    check_out: nil,
    deposit: nil,
    monthly_rent: nil,
    utilities: nil
  }

  setup %{conn: conn} do
    {:ok,
     conn: put_req_header(conn, "accept", "application/json"), apartment: apartment_fixture()}
  end

  describe "create booking" do
    test "renders booking when data is valid", %{conn: conn, apartment: apartment} do
      b = Map.merge(@create_attrs, %{apartment_id: apartment.id})
      conn = post(conn, ~p"/api/bookings", booking: b)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/bookings/#{id}")

      assert %{
               "id" => ^id,
               "check_in" => "2023-03-26",
               "check_out" => "2023-03-26",
               "deposit" => 100_000,
               "monthly_rent" => 250_000,
               "utilities" => 20000
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, apartment: apartment} do
      b = Map.merge(@invalid_attrs, %{apartment_id: apartment.id})
      conn = post(conn, ~p"/api/bookings", booking: b)
      assert json_response(conn, 400)["errors"] == %{"detail" => "Invalid params"}
    end

    test "renders errors when apartment is already booked", %{conn: conn} do
      %{apartment_id: apartment_id} =
        booking_fixture(%{check_in: ~D[2024-05-26], check_out: ~D[2024-06-26]})

      booking_params = %{
        "check_in" => ~D[2024-05-30],
        "check_out" => ~D[2023-06-29],
        "apartment_id" => apartment_id
      }

      conn = post(conn, ~p"/api/bookings", booking: booking_params)

      assert json_response(conn, 401)["errors"] == %{
               "detail" => "Apartment not available to book in the specified dates"
             }
    end
  end
end
