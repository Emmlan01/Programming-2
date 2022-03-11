defmodule Der do
  IO.puts("Hello!")
  @type literal() :: {:num, number()} | {:var, atom()}

  @type expr() :: literal() #används för dokumentation
  | {:add, expr(), expr()}
  | {:mul, expr(), expr()}
  | {:exp, expr(), literal()}
  | {:div, literal(), expr()}
  | {:ln, expr()}
  | {:sqrt, expr()}
  | {:sin, expr()}  #funkar ej
  | {:cos, expr()}    #funkar ej

  def test1() do
    e =  {:sin, {:exp, {:var , :x}, {:num, 5}}}
  d = deriv(e, :x)
  c = calc(d, :x, 0)
  IO.write("expression: #{pprint(e)}\n")
  IO.write("deritave: #{pprint(d)}\n")
  IO.write("simplified: #{pprint(simplify(d))}\n")
  IO.write("calculated: #{pprint(simplify(c))}\n")
  :ok
  end

  def test2() do
  q = {:var, :x}
    e = {:mul, q}
  d = deriv(e, :x)
  c = calc(d, :x, 4)
  IO.write("expression: #{pprint(e)}\n")
  IO.write("deritave: #{pprint(d)}\n")
  IO.write("simplified: #{pprint(simplify(d))}\n")
  IO.write("calculated: #{pprint(simplify(c))}\n")
  :ok
  end



  def deriv({:num, _}, _) do {:num, 0} end # derivatan av en konstant siffra
  def deriv({:var, v}, v) do {:num, 1} end # derivatan av en variabel
  def deriv({:var, _}, _) do {:num, 0} end
  def deriv({:add, e1, e2}, v) do # derivatan av en f + g
    {:add, deriv(e1, v), deriv(e2, v)}
  end
  def deriv({:mul, e1, e2}, v) do # derivatan för f *g
    {:add,
    {:mul, deriv(e1, v), e2},
    {:mul, e1, deriv(e2, v)}}
  end

  def deriv({:exp, e, {:num, n}}, v) do
    {:mul,
      {:mul, {:num, n}, {:exp, e, {:num, n - 1}}},
    deriv(e, v)}
  end

  def deriv({:div, {:num, n}, e}, v) do
    {:mul,{:num, n}, deriv({:exp, e, {:num, -1}}, v)}
  end

  def deriv({:ln, e}, v) do
    case e do
      {:var, v} -> {:exp, {:var, v}, {:num, -1}}
      _ -> {:mul, deriv(e, v), {:exp, e, -1}}
    end
    #{:div, {:mul, {:num, n}, deriv(e, v)}, {:var, v}}
  end

  def deriv({:sqrt, e}, v) do
    deriv({:exp, e, {:num, 0.5}}, v)
  end

  def deriv({:sin, e}, v) do
    case e do
      #{:var, v} -> {:sin, {:add, {:var, v}, {:num, 90}}}
     # _ -> {:mul, deriv(e, v), {:sin, {:add, e, {:num, 90}}}}
      {:var, v} -> {:cos,  {:var, v}}
     _ ->  {:mul,deriv(e, v), {:cos, e}}
    end
  #  {:mul, {:cos, e}, deriv(e, v)}
  end

  #def deriv({:cos, e}, v) do
  #  {:var, v} -> {:sin + 90, {:add, {:var, v}, {:num, 90}}}
  #  _ -> {:mul, deriv(e, v), {:sin + 90, {:add, e, {:num, 90}}}}
    #{:mul, {:num, -1}, {:mul, {:sin, e}, deriv({e}, v)}}
  #end


  def calc({:num, n}, _, _) do {:num, n} end
  def calc({:var, v}, v, n) do {:num, n} end
  def calc({:var, v}, _, _) do {:var, v} end
  def calc({:add, e1, e2}, v, n) do
    {:add, calc(e1, v, n), calc(e2, v, n)}
  end
  def calc({:mul, e1, e2}, v, n) do
    {:mul, calc(e1, v, n), calc(e2, v, n)}
  end
  def calc({:exp, e1, e2}, v, n) do
    {:exp, calc(e1, v, n), calc(e2, v, n)}
  end
  def calc({:div, e1, e2}, v, n) do
    {:div, calc(e1, v, n), calc(e2, v, n)}
  end
  def calc({:ln, e1}, v, n) do
    {:ln, calc(e1, v, n)}
  end
  def calc({:sqrt, e1}, v, n) do
    {:sqrt, calc(e1, v, n)}
  end
  def calc({:sin, e1}, v, n) do
    {:sin, calc(e1, v, n)}
  end
  def calc({:cos, e1}, v, n) do
    {:cos, calc(e1, v, n)}
  end



  def simplify({:add, e1, e2}) do
    simplify_add(simplify(e1), simplify(e2))
  end
  def simplify({:mul, e1, e2}) do
    simplify_mul(simplify(e1), simplify(e2))
  end
  def simplify({:exp, e1, e2}) do
    simplify_exp(simplify(e1), simplify(e2))
  end
  def simplify({:div, e1, e2}) do
    simplify_div(simplify(e1), simplify(e2))
  end
  def simplify({:ln, e1}) do
    simplify_ln(simplify(e1))
  end
  def simplify({:sqrt, e1}) do
    simplify_sqrt(simplify(e1))
  end
  def simplify({:sin, e1}) do
    simplify_sin(simplify(e1))
  end
  def simplify({:cos, e1}) do
    simplify_cos(simplify(e1))
  end
  def simplify(e) do e end

  def simplify_add({:num, 0}, e2) do e2 end
  def simplify_add(e1, {:num, 0}) do e1 end
  def simplify_add({:num, n1}, {:num, n2}) do {:num, n1 + n2} end
  def simplify_add(e1, e2) do {:add, e1, e2} end

  def simplify_mul({:num, 0}, _) do {:num, 0} end
  def simplify_mul(_, {:num, 0}) do {:num, 0} end
  def simplify_mul({:num, 1}, e2) do e2 end
  def simplify_mul(e1, {:num, 1}) do e1 end
  def simplify_mul({:num, n1}, {:num, n2}) do {:num, n1 * n2} end
  def simplify_mul(e1, e2) do {:mul, e1, e2} end

  def simplify_exp(_, {:num, 0}) do {:num, 1} end
  def simplify_exp(e1, {:num, 1}) do e1 end
  def simplify_exp({:num, n1}, {:num, n2}) do {:num, :math.pow(n1, n2)} end
  def simplify_exp(e1, e2) do {:exp, e1, e2} end

  def simplify_div({:num, 0}, _) do {:num, 0} end
  def simplify_div(_, {:num, 0}) do {:error} end
  def simplify_div({:num, n}, {:num, 1}) do {:num, n} end
  def simplify_div({:num, n1}, {:num, n2}) do {:num, n1 / n2} end
  def simplify_div(e1, e2) do {:div, e1, e2} end

  def simplify_ln({:num, 0}) do {:error} end
  def simplify_ln({:num, n}) do {:num, :math.log(n)} end
  def simplify_ln(e1) do {:ln, e1} end

  def simplify_sqrt({:num, 0}) do {:num, 0} end
  def simplify_sqrt({:num, n}) do {:num, :math.sqrt(n)} end
  def simplify_sqrt(e1) do {:sqrt, e1} end

  def simplify_sin({:num, 0}) do {:num, 0} end
  def simplify_sin({:num, n}) do {:num, :math.sin(n)} end
  def simplify_sin(e1) do {:sin, e1} end

  def simplify_cos({:num, 1}) do {:num, 0} end
  def simplify_cos({:num, n}) do {:num, :math.cos(n)} end
  def simplify_cos(e1) do {:cos, e1} end

  def pprint({:num, n}) do "#{n}" end
  def pprint({:var, n}) do "#{n}" end
  def pprint({:add, e1, e2}) do "(#{pprint(e1)}) + (#{pprint(e2)})" end
  def pprint({:mul, e1, e2}) do "(#{pprint(e1)}) * (#{pprint(e2)})" end
  def pprint({:exp, e1, e2}) do "(#{pprint(e1)}) ^ (#{pprint(e2)})" end
  def pprint({:div, e1, e2}) do "(#{pprint(e1)}) / (#{pprint(e2)})" end
  def pprint({:ln, e1}) do "(ln(#{pprint(e1)})" end
  def pprint({:sqrt, e1}) do "sqrt(#{pprint(e1)})" end
  def pprint({:sin, e1}) do "sin(#{pprint(e1)})" end
  def pprint({:cos, e1}) do "cos(#{pprint(e1)})" end


  end
