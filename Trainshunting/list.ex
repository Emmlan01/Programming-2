defmodule Operations do

  def take([], _) do [] end
  def take([h | t], 0) do [] end     #
  def take([h | t], n) do             #vi vill ha n antal element. vi skickar tbx första h, sen rekursivt anropar på tailen och antalet -1.
    [h | take(t, n-1)]
  end

  def drop([], _) do [] end
  def drop(xs, 0) do xs end       #om n=0 returnerar vi hela resten av listan
  def drop([h | t], n) do
    drop(t, n-1)
  end

  def append(xs,[]) do xs end
  def append(xs, [h | t]) do
    append(xs ++ [h], t)      #[qw][as] -> [qwa][s] -> [qwas]=xs
  end

  def member([], y) do false end
  def member([h | t], y) do
    cond do
      y == h -> true
      true -> member(t,y)
    end
  end

  def position(xs, y) do
    position(xs, y, 0)
  end
  def position([h | t], y, i) do
    cond do
      y == h -> i + 1
      true -> position(t, y, i + 1)
    end
  end

end
