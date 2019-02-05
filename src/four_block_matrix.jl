struct FourBlockMatrix <: AbstractArray{Float64,2}
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
