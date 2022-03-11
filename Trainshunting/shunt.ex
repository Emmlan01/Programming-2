defmodule Shunt do

  def split(list, y) do
    {Operations.take(list, Operations.position(list, y) - 1), Operations.drop(list, Operations.position(list, y))}
  end

  def find([],[]) do [] end
  def find(xs, [h | t]) do
    {l1,l2} = split(xs, h)
    [{:one, Enum.count(l2)+ 1}, {:two,Enum.count(l1)}, {:one, -1 * (Enum.count(l2) + 1)}, {:two, Enum.count(l1) * -1} | find(Operations.append(l2,l1), t)]
  end

  def few([],[]) do [] end
  def few([hx|tx], [h | t]) do
    {l1,l2} = split([hx|tx], h)
    cond do
      hx == h -> few(tx,t)
      true -> [{:one, Enum.count(l2)+ 1}, {:two,Enum.count(l1)}, {:one, -1 * (Enum.count(l2) + 1)}, {:two, Enum.count(l1) * -1} | few(Operations.append(l2,l1), t)]
    end
  end

  def remove([]) do [] end
  def remove([{_,0}|[]]) do [] end
  def remove([h|[]]) do [h] end
  def remove([{h1,n},{h2,m}| t]) do
    cond do
      h1 == h2 -> remove([{h1, n + m}|t])
      m == 0 -> remove([{h2,m}|t])
      true -> [{h1,n}| remove([{h2,m}| t])]
    end
  end

  def compress(list) do
    rl = remove(list)
    cond do
      rl == list -> list
      true -> compress(rl)
    end
  end
end
