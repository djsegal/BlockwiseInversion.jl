function getindex(cur_matrix::FourBlockMatrix,i::Int,j::Int)
  n = cur_matrix.n
  m = cur_matrix.m

  @assert i <= n + m
  @assert j <= n + m

  if i <= n
    if j <= n
      cur_value = cur_matrix.A[i,j]
    else
      cur_value = cur_matrix.B[i,j-n]
    end
  else
    if j <= n
      cur_value = cur_matrix.C[i-n,j]
    else
      cur_value = cur_matrix.D[i-n,j-n]
    end
  end

  cur_value
end
