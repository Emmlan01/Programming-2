defmodule Huffman do

  def sample do
    'the quick brown fox jumps over the lazy dog
    this is a sample text that we will use when we build
    up a table we will only handle lower case letters and
    no punctuation symbols the frequency will of course not
    represent english but it is probably not that far off'
  end

  def text() do
    'this is something that we should encode'
  end

  def testt do
    sample = sample()
    tree = tree(sample)
    encode = encode_table(tree)
    decode = encode_table(tree, [])
    text = text()
    seq = encode(text, encode)
    decode(seq, decode)
  end

  def tree(sample) do
    freq = freq(sample)
    huffman_tree(freq)
  end

  #Beräkna freq av alla characters i sample texten
  #och returnera med en list av tuples{char, freq}
  def freq(sample) do
    freq(sample, [])
  end

  def freq([], freq) do
    freq
  end

  def freq([char | rest], freq) do
    freq(rest, insertFreq(char, freq))
  end

  def insertFreq(char, []) do
    [{char, 1}]
  end

  def insertFreq(char, [{char, n} | freq]) do
    [{char, n + 1} | freq]
  end

  def insertFreq(char, [elem | freq]) do
    [elem | insertFreq(char, freq)]
  end

  #Implementera Huffman tree från en character freq list
  def huffman_tree([{tree, _}]) do
    tree
  end

  def huffman_tree([{a, af}, {b, bf} | rest]) do
    res=insert({{a, b}, af + bf}, rest)
    huffman_tree(res)
  end

  def insert({a, af}, []) do
   [{a, af}]
  end

  def insert({a, af}, [{b, bf} | rest]) when af < bf do
    [{a, af}, {b, bf} | rest]
  end

  def insert({a, af}, [{b, bf} | rest]) do
    [{b, bf} | insert({a, af}, rest)]
  end

  #Encoding table. Där 0 är vänster och 1 är höger.
  def encode_table(tree) do
    encode_table(tree, [])
  end
  def encode_table({left_branch, right_branch}, table) do
    left = encode_table(left_branch, [0 | table])
    right = encode_table(right_branch, [1 | table])
    left ++ right
  end
  def encode_table(node, table) do
    [{node, reverse(table)}]
  end

  def reverse(list) do reverse(list,[]) end
  def reverse([], reversed) do reversed end
  def reverse([h|t], reversed) do
    reverse(t,[h|reversed])
  end

  # Tar emot en lista av tuples och returnerar en lista av bits
  # som motsvarar characterna i table.
  def encode([], _) do [] end
  def encode([head|tail], table) do
    case lookup(head,table) do
        {:found, code} -> code ++ encode(tail, table)
        {:notfound, msg} -> msg
    end
  end

  def lookup(head, [{head,code}|_rest]) do
    {:found, code}
  end
  def lookup(head, [{_fc,_code}|rest]) do
    lookup(head, rest)
 end
  def lookup(_, _) do
     {:notfound, "The character is not found in this encoding table"}
  end

  # Decoding en sekvent av bitar från Huffman tree.

  def decode([], _) do
    []
  end

  def decode(seq, table) do
    {char, rest} = decode_char(seq, 1, table)
    [char | decode(rest, table)]
  end

  def decode_char(seq, n, table) do
    {code, rest} = Enum.split(seq, n)
    case List.keyfind(table, code, 1) do
      {char, _} ->
        {char, rest}
      nil ->
        decode_char(seq, n + 1, table)
    end
  end

end
