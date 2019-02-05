function size(cur_matrix::FourBlockMatrix)
  cur_dim = cur_matrix.n + cur_matrix.m
  (cur_dim, cur_dim)
end

# function size(cur_matrix::FourBlockMatrix, cur_index::Int)
#   cur_dim = cur_matrix.n + cur_matrix.m
#   (cur_dim, cur_dim)[cur_index]
# end

# function length(cur_matrix::FourBlockMatrix)
#   cur_size = size(cur_matrix)
#   prod(cur_size)
# end

# function Matrix(cur_matrix::FourBlockMatrix)
#   A, B, C, D = map(Matrix, get_sub_matrices(cur_matrix))

#   tmp_matrix = vcat(
#     hcat(A, B), hcat(C, D)
#   )

#   tmp_matrix
# end

# rank(cur_matrix::FourBlockMatrix) = rank(Matrix(cur_matrix))

# println(cur_matrix::FourBlockMatrix) = println(Matrix(cur_matrix))
# display(cur_matrix::FourBlockMatrix) = display(Matrix(cur_matrix))
# show(cur_matrix::FourBlockMatrix) = show(Matrix(cur_matrix))

# function lastindex(cur_matrix::FourBlockMatrix, cur_index::Int64)
#   cur_matrix.n + cur_matrix.m
# end
