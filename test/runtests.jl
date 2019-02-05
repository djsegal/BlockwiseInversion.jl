using BlockwiseInversion
using Test

@testset "BlockwiseInversion.jl" begin

  t = 250

  b = rand(t)

  test_matrix = nothing

  test_matrix = zeros(t,t)

  for i in 1:t
    j = i
    test_matrix[i,j] = j + (i-1) * (t)

    if i > 1
      j = i - 1
      test_matrix[i,j] = j + (i-1) * (t)
    end

    if i < t
      j = i + 1
      test_matrix[i,j] = j + (i-1) * (t)
    end
  end

  test_vector = test_matrix \ b

  for n in 0:10:t

    println(10000000+n)

    m = t - n
    d = 1

    cur_matrix = FourBlockMatrix(n,m,d,d)

    @test size(cur_matrix.A) == (n,n)
    @test size(cur_matrix.D) == (m,m)

    for i in 1:t
      j = i
      cur_matrix[i,j] = j + (i-1) * (t)

      if i > 1
        j = i - 1
        cur_matrix[i,j] = j + (i-1) * (t)
      end

      if i < t
        j = i + 1
        cur_matrix[i,j] = j + (i-1) * (t)
      end
    end

    cur_vector = cur_matrix \ b

    @test sum( abs.( test_matrix .- cur_matrix ) ) / t < 1e-14
    @test sum( abs.( test_vector .- cur_vector ) ) / t < 1e-14

  end


end
