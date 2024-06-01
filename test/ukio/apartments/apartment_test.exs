defmodule Ukio.ApartmentTest do
  use Ukio.DataCase

  alias Ukio.Apartments.Apartment

  describe "calculate costs" do
    import Ukio.ApartmentsFixtures

    test "calculate_costs/1 returns its associated costs" do
      apartment = apartment_fixture()

      assert Apartment.calculate_costs(apartment) == {20_000, 100_000}
    end

    test "calculate_costs/1 returns mars market specific costs" do
       apartment = apartment_fixture(%{market: "Mars", monthly_price: 45_000, square_meters: 300})

       assert Apartment.calculate_costs(apartment) == {3_000, 45_000}
    end
  end
end