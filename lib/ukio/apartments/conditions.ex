defmodule Ukio.Apartments.Conditions do
  @moduledoc """
  Calculate the different conditions associated with an apartment on a market
  """

  alias Ukio.Apartments.Apartment

  defstruct [:deposit, :utilities]

  @type t :: %__MODULE__{
          deposit: pos_integer,
          utilities: pos_integer
        }

  @spec calculate(Apartment.t()) :: __MODULE__.t()
  def calculate(%Apartment{market: "Mars"} = apartment) do
    %__MODULE__{
      deposit: apartment.monthly_price,
      utilities: 10 * apartment.square_meters
    }
  end

  def calculate(%Apartment{} = _apartment) do
    %__MODULE__{
      deposit: 100_000,
      utilities: 20_000
    }
  end
end
