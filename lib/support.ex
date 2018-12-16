defmodule Support do
    
    def color_this(str, color) do
        :erlang.apply(IO.ANSI, color, [])
          <> str <> IO.ANSI.default_color()
    end

    def timestamp(t) do
        hours = t.hour() |> two_digits_string() 
        minutes = t.minute() |> two_digits_string()
        seconds = t.second() |> two_digits_string()
        hours <> ":" <> minutes <> ":" <> seconds
    end

    defp two_digits_string(number) do
        num_string = number |> Integer.to_string
        digits = num_string |> String.length
        if digits == 1 do "0" <> num_string else num_string  end
    end
end