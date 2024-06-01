defmodule Ukio.Apartments.Apartment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "apartments" do
    field :address, :string
    field :monthly_price, :integer
    field :name, :string
    field :square_meters, :integer
    field :zip_code, :string
    # Add a field to track to which market belongs this apartment
    # Ideally, this would be a new entity by itself, to be reused across many apartments and being able to
    # Add, remove, manage markets. For the sake of keeping it simple, it's just a field in this exercise.
    field :market, :string

    timestamps()
  end

  @type t :: %__MODULE__{
          address: binary,
          monthly_price: pos_integer,
          name: binary,
          square_meters: pos_integer,
          zip_code: binary,
          market: binary
        }

  @doc false
  def changeset(apartment, attrs) do
    apartment
    |> cast(attrs, [:name, :address, :zip_code, :monthly_price, :square_meters, :market])
    |> validate_required([:name, :address, :zip_code, :monthly_price, :square_meters, :market])
  end
end
