function \(cur_matrix::FourBlockMatrix, cur_vector::Vector)

  A, B, C, D = get_sub_matrices(cur_matrix)

  iszero(cur_matrix.n) && return D \ cur_vector
  iszero(cur_matrix.m) && return A \ cur_vector

  top_b = view(cur_vector, 1:cur_matrix.n)
  bot_b = view(cur_vector, cur_matrix.n .+ (1:cur_matrix.m) )

  cur_lu = lu(A)
  F = SharedArray{Float64}(cur_matrix.m,cur_matrix.m)

  @sync @distributed for j = 1:size(B,2)
    tmp_B = B[:,j]
    isempty(tmp_B) && continue
    F[:,j] = C * ( cur_lu \ Vector(tmp_B) )
  end

  G = D - F

  L_1 = A \ top_b

  L_2 = G \ ( C * L_1 )

  top_left = L_1 + A \ ( B * L_2 )
  bot_left = - L_2

  R_1 = G \ bot_b

  top_right = - A \ ( B * R_1 )
  bot_right = R_1

  vcat(
    ( top_left .+ top_right ),
    ( bot_left .+ bot_right )
  )

end
