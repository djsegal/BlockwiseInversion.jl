function size(cur_matrix::FourBlockMatrix)
  cur_dim = cur_matrix.n + cur_matrix.m
  (cur_dim, cur_dim)
end
