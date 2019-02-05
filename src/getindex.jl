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

# getindex(cur_matrix::FourBlockMatrix, i::Int, j::Colon) = cur_matrix[i,1:end]
# getindex(cur_matrix::FourBlockMatrix, i::Colon, j::Int) = cur_matrix[1:end,j]

# getindex(cur_matrix::FourBlockMatrix, i::Int, j::UnitRange) = map(tmp_j -> cur_matrix[i,tmp_j], j)
# getindex(cur_matrix::FourBlockMatrix, i::UnitRange, j::Int) = map(tmp_i -> cur_matrix[tmp_i,j], i)

# getindex(cur_matrix::FourBlockMatrix, cur_colon::Colon) = cur_matrix[:,:][:]
# getindex(cur_matrix::FourBlockMatrix, i::Colon, j::Colon) = cur_matrix[1:end,1:end]

# function getindex(cur_matrix::FourBlockMatrix, i::UnitRange, j::UnitRange)
#   tmp_matrix = zeros(length(i),length(j))
#   for (cur_index, tmp_i) in enumerate(i)
#     for (cur_sub_index, tmp_j) in enumerate(j)
#       tmp_matrix[cur_index, cur_sub_index] = cur_matrix[tmp_i, tmp_j]
#     end
#   end
#   tmp_matrix
# end
