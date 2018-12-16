defmodule Support do
    @moduledoc """
    Documentation for Support.
    """

    @doc """
    Given a string and a color it returns that string with said color.
    """
    def color_this(str, color) do
        :erlang.apply(IO.ANSI, color, [])
          <> str <> IO.ANSI.default_color()
    end

    @doc """
    Returns a given UTC time formatted to HH:MM:SS.
    """
    def timestamp(t) do
        hours = t.hour() |> two_digits_string() 
        minutes = t.minute() |> two_digits_string()
        seconds = t.second() |> two_digits_string()
        hours <> ":" <> minutes <> ":" <> seconds
    end

    defp two_digits_string(number) do
        num_string = number |> Integer.to_string
        if String.length(num_string) == 1 do "0" <> num_string else num_string  end
    end
end