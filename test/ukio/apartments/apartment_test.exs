defmodule Ukio.ConditionsTest do
  use Ukio.DataCase

  alias Ukio.Apartments.Conditions

  describe "calculate costs" do
    import Ukio.ApartmentsFixtures

    test "calculate/1 returns its associated costs" do
      apartment = apartment_fixture()

      assert Conditions.calculate(apartment) == %Conditions{utilities: 20_000, deposit: 100_000}
    end

    test "calculate/1 returns mars market specific costs" do
      apartment = apartment_fixture(%{market: "Mars", monthly_price: 45_000, square_meters: 300})

      assert Conditions.calculate(apartment) == %Conditions{utilities: 3_000, deposit: 45_000}
    end
  end
end
