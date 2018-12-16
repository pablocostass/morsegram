defmodule Support do

    @doc """
    Given a string and a color it returns that string with the given color.
    """
    def color_this(str, color) do
        :erlang.apply(IO.ANSI, color, [])
          <> str <> IO.ANSI.default_color()
    end

    @doc """
    Given the current time it returns it formatted to HH:MM:SS.
    """
    def timestamp(t) do
        hours = t.hour() |> two_digits_string() 
        minutes = t.minute() |> two_digits_string()
        seconds = t.second() |> two_digits_string()
        hours <> ":" <> minutes <> ":" <> seconds
    end

end