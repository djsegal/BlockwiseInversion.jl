module BlockwiseInversion

  using Revise
  using Reexport

  @reexport using BandedMatrices
  @reexport using Distributed
  @reexport using LinearAlgebra
  @reexport using SharedArrays
  @reexport using SparseArrays

  export FourBlockMatrix

  import Base: length, \, size
  import Base: getindex, setindex!, lastindex
  import Base: println, show, display

  import LinearAlgebra: rank

  struct FourBlockMatrix
    A::BandedMatrix
    B::SparseMatrixCSC
    C::SparseMatrixCSC
    D::Matrix

    n::Int
    m::Int

    l::Int
    u::Int
  end

  function FourBlockMatrix(n::Int,m::Int,l::Int,u::Int)

    A = BandedMatrix(Zeros(n,n), (l,u))

    B = spzeros(n,m)
    C = spzeros(m,n)

    D = zeros(m,m)

    cur_matrix = FourBlockMatrix(
      A, B, C, D,
      n, m, l, u
    )

  end

  function get_sub_matrices(cur_matrix::FourBlockMatrix)
    A, B, C, D = map(
      cur_field -> getfield(cur_matrix, cur_field),
      [:A, :B, :C, :D]
    )

    [A, B, C, D]
  end

  function \(cur_matrix::FourBlockMatrix, cur_vector::Vector)

    top_b = view(cur_vector, 1:cur_matrix.n)
    bot_b = view(cur_vector, cur_matrix.n .+ (1:cur_matrix.m) )

    A, B, C, D = get_sub_matrices(cur_matrix)

    cur_lu = lu(A)

    F = SharedArray{Float64}(size(D))

    @distributed for j = 1:size(B,2)
      F[:,j] = C * ( cur_lu \ Vector(B[:,j]) )
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

  function size(cur_matrix::FourBlockMatrix)
    cur_dim = cur_matrix.n + cur_matrix.m
    (cur_dim, cur_dim)
  end

  function size(cur_matrix::FourBlockMatrix, cur_index::Int)
    cur_dim = cur_matrix.n + cur_matrix.m
    (cur_dim, cur_dim)[cur_index]
  end

  function length(cur_matrix::FourBlockMatrix)
    cur_size = size(cur_matrix)
    prod(cur_size)
  end

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

  getindex(cur_matrix::FourBlockMatrix, i::Int, j::Colon) = cur_matrix[i,1:end]
  getindex(cur_matrix::FourBlockMatrix, i::Colon, j::Int) = cur_matrix[1:end,j]

  getindex(cur_matrix::FourBlockMatrix, i::Int, j::UnitRange) = map(tmp_j -> cur_matrix[i,tmp_j], j)
  getindex(cur_matrix::FourBlockMatrix, i::UnitRange, j::Int) = map(tmp_i -> cur_matrix[tmp_i,j], i)

  getindex(cur_matrix::FourBlockMatrix, cur_colon::Colon) = cur_matrix[:,:][:]
  getindex(cur_matrix::FourBlockMatrix, i::Colon, j::Colon) = cur_matrix[1:end,1:end]

  function getindex(cur_matrix::FourBlockMatrix, i::UnitRange, j::UnitRange)
    tmp_matrix = zeros(length(i),length(j))
    for (cur_index, tmp_i) in enumerate(i)
      for (cur_sub_index, tmp_j) in enumerate(j)
        tmp_matrix[cur_index, cur_sub_index] = cur_matrix[tmp_i, tmp_j]
      end
    end
    tmp_matrix
  end

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

  setindex!(cur_matrix::FourBlockMatrix,cur_value::Any,i_range::UnitRange,j::Int) =
    foreach(i -> setindex!(cur_matrix,cur_value,i,j), i_range)

  setindex!(cur_matrix::FourBlockMatrix,cur_value::Any,i::Int,j_range::UnitRange) =
    foreach(j -> setindex!(cur_matrix,cur_value,i,j), j_range)

  setindex!(cur_matrix::FourBlockMatrix,cur_value::Any,i_range::UnitRange,j_range::UnitRange) =
    foreach(j -> setindex!(cur_matrix,cur_value,i_range,j), j_range)

  function Matrix(cur_matrix::FourBlockMatrix)
    A, B, C, D = map(Matrix, get_sub_matrices(cur_matrix))

    tmp_matrix = vcat(
      hcat(A, B), hcat(C, D)
    )

    tmp_matrix
  end

  rank(cur_matrix::FourBlockMatrix) = rank(Matrix(cur_matrix))

  println(cur_matrix::FourBlockMatrix) = println(Matrix(cur_matrix))
  display(cur_matrix::FourBlockMatrix) = display(Matrix(cur_matrix))
  show(cur_matrix::FourBlockMatrix) = show(Matrix(cur_matrix))

  function lastindex(cur_matrix::FourBlockMatrix, cur_index::Int64)
    cur_matrix.n + cur_matrix.m
  end

end
