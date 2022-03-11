defmodule Move do

  def single({track, n}, {main, track1, track2}) do
    case track do
      :one -> cond do
        n > 0  -> {Operations.take(main, Enum.count(main) - n), Operations.append(Operations.drop(main, Enum.count(main) - n), track1), track2}
        n < 0  -> {Operations.append(main, Operations.take(track1, - n)), Operations.drop(track1, - n), track2}
        true -> {main, track1, track2}
      end
      :two -> cond do
        n > 0 -> {Operations.take(main, Enum.count(main) - n), track1, Operations.append(Operations.drop(main, Enum.count(main) - n), track2)}
        n < 0 -> {Operations.append(main, Operations.take(track2, - n)), track1, Operations.drop(track2, - n)}
        true -> {main, track1, track2}
      end
    end
  end

  def move([], state) do [state] end
  def move([h | t], state) do
    [state | move(t, single(h, state))]     #sparar state jag börjar på, sen rekursivt kallar på move, och hämtar state från single.
  end
end
