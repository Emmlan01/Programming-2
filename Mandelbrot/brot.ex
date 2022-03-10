defmodule Brot do

  def mandelbrot(c, m) do
    z0 = Cmplx.new(0, 0)
    i = 0
    test(i, z0, c, m)
  end

  def test(max, _, _, max) do
    0
  end

  #def test(i, z0, c, m) do
  #  cond do
  #    Cmplx.abs(z0) <= 2 ->
   #     z1 = Cmplx.add(Cmplx.sqr(z0), c)
   #     test(i + 1, z1, c, m)
    #    true -> i
   # end
  #end

  def test(i, z0, c, m) do
      zn = Cmplx.add(Cmplx.sqr(z0), c)
    cond do
    Cmplx.abs(zn) > 2 -> i
       #  i == m ->
        #  0
      true ->
        test(i + 1, zn, c, m)
      end
    end
end
