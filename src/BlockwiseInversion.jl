module BlockwiseInversion

  using Revise
  using Reexport

  @reexport using BandedMatrices
  @reexport using Distributed
  @reexport using LinearAlgebra
  @reexport using SharedArrays
  @reexport using SparseArrays

  import Base: length, \, size
  import Base: getindex, setindex!, lastindex
  import Base: println, show, display

  import LinearAlgebra: rank

  export FourBlockMatrix

  include("four_block_matrix.jl")
  include("array_operations.jl")

  include("getindex.jl")
  include("setindex.jl")

  include("ldiv.jl")
  include("get_sub_matrices.jl")


end
