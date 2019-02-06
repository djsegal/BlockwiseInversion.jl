function setindex!(cur_matrix::FourBlockMatrix,cur_value::Any,i::Int,j::Int)
  n = cur_matrix.n
  m = cur_matrix.m

  @assert i <= n + m
  @assert j <= n + m

  if i <= n
    if j <= n
      cur_matrix.A[i,j] = cur_value
    else
      cur_matrix.B[i,j-n] = cur_value
    end
  else
    if j <= n
      cur_matrix.C[i-n,j] = cur_value
    else
      cur_matrix.D[i-n,j-n] = cur_value
    end
  end
end
