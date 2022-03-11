defmodule Prime do
  def bench() do
   # ls = [, 2000, 4000, 8000, 16000, 32000, 64000, 128000]
    ls = [16,32,64,128,256,512,1024,2*1024,4*1024,8*1024, 10*1024,12*1024]
    #ls = [100 , 1000, 10000, 100000]
    bench(ls)
  end
  def bench([h | t]) do
    IO.write("  #{primtal1(h)}\t\t\t\t#{primtal2(h)}\t\t\t\t#{primtal3(h)}\n")
    case t do
      [] -> :ok
      _ -> bench(t)
    end
  end

  def primtal1(n) do
    lists = Enum.to_list(2..n)
    {uSecs, :ok} = :timer.tc( fn  -> prim1(lists)
                              :ok end)
    uSecs
  end
  def primtal2(n) do
    lists = Enum.to_list(2..n)
    {uSecs, :ok} = :timer.tc( fn  -> prim2(lists)
                              :ok end)
    uSecs
  end
  def primtal3(n) do
    lists = Enum.to_list(2..n)
    {uSecs, :ok} = :timer.tc( fn  -> prim3(lists)
                              :ok end)
    uSecs
  end

  def prim1([]) do [] end
  def prim1([h|t]) do [h|prim1(Enum.filter(t, fn(x) -> rem(x,h) != 0 end))] end

  def prim2(list) do
    prim2(list, [])
  end
  def prim2([], primtal) do
    primtal
  end
  def prim2([h | t], []) do
    prim2(t, [h])     #om primtalslistan är tom lägger vi in head (2) i primtalslistan
  end

  def prim2([h | t], primtal) do
    prim2(t, div_prime2(h, primtal))
  end

  def div_prime2(e, [h | []]) do
    cond do
      rem(e, h) != 0 -> [h, e]
       true -> [h]
    end
  end
  def div_prime2(e, [h | t]) do
      cond do
        rem(e, h) != 0 -> [h | div_prime2(e, t)]
        true -> [h | t]       #hela listan returneras
      end
  end

 #kallar på reverse, sen prim3 med lista, tom lista och tomlista.
  def prim3(list) do
      reverse(prim3(list, []))
  end

  #
  def prim3([], primes) do
    primes
  end
  def prim3([h | t], []) do
    prim3(t, [h])
  end
  def prim3([h | t], primes) do
    prim3(t, div_prime3(h, primes, primes))
  end
  def div_prime3(tal, [h | []], primes) do
    cond do
      rem(tal, h) != 0 -> [tal | primes]
      true -> primes
    end
  end
  def div_prime3(tal, [h | t], primes) do
    cond do
      rem(tal, h) != 0 -> div_prime3(tal, t, primes)
      true -> primes
    end
  end

  def reverse(list) do
    Enum.reverse(list)
  end

 # def reverse([], l) do
  #  l
 # end
 # def reverse([h | t], l) do
 #   reverse(t, [h | l])
  #end
end
