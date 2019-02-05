function get_sub_matrices(cur_matrix::FourBlockMatrix)
  A, B, C, D = map(
    cur_field -> getfield(cur_matrix, cur_field),
    [:A, :B, :C, :D]
  )

  [A, B, C, D]
end
