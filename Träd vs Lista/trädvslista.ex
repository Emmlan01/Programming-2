defmodule Bench do

  def bench() do bench(100) end

  def bench(l) do

    ls = [16,32,64,128,256,512,1024,2*1024,4*1024,8*1024]

    time = fn (i, f) ->
      seq = Enum.map(1..i, fn(_) -> :rand.uniform(100000) end)
      elem(:timer.tc(fn () -> loop(l, fn -> f.(seq) end) end),0)
    end

    bench = fn (i) ->

      list = fn (seq) ->
        List.foldr(seq, list_new(), fn (e, acc) -> list_insert(e, acc) end)
      end

      tree = fn (seq) ->
        List.foldr(seq, tree_new(), fn (e, acc) -> tree_insert(e, acc) end)
      end

      tl = time.(i, list)
      tt = time.(i, tree)

      IO.write("  #{tl}\t\t\t#{tt}\n")
    end

    IO.write("# benchmark of lists and tree (loop: #{l}) \n")
    Enum.map(ls, bench)

    :ok
  end

  def loop(0,_) do :ok end
  def loop(n, f) do
    f.()
    loop(n-1, f)
  end

  def list_new() do [] end   #skapa en tom lista

  def list_insert(e, []) do [e] end   #sätter in element i listan om listan är tom sen innan

  def list_insert(e, [h|t])       #Sätter in element e om det är mindre än head som först i listan för att få ordnad lista.
     when e <= h do [e,h|t]
  end

  def list_insert(e, [h|t]) do      #annars sätter vi in element i listan.
     [h|list_insert(e,t)]
  end

  def tree_new() do :nil end      #tom träd

  def tree_insert(e, :nil) do {:leaf, e} end    #sätter in första elementet som roten

  def tree_insert(e, {:leaf, val}) do     #om elementet är mindre än value så ska en ny nod skapas och lövet till vänster får värde e och den till höger null
    cond do
      e < val ->  {:node, val, {:leaf, e}, {:leaf, nil}}
      true ->  {:node, val, {:leaf, nil}, {:leaf, e}}
    end
  end

  def tree_insert(e, {:node, val, left, right}) do      #letar rekursivt ner åt vänster om elemenetet är mindre än value och sätter in på rätt plats.
    cond do
      e < val -> {:node, val, tree_insert(e, left), right}
      true -> {:node, val, left, tree_insert(e, right)}
    end
  end

  end
