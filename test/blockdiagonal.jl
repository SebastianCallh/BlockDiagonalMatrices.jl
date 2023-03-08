@testset "block diagonal" begin

    # construction
    A = rand(5, 5)
    B = rand(3, 3)

    B1 = BlockDiagonal([A, B])
    B2 = BlockDiagonal([A, B])
    B3 = BlockDiagonal([A, [1.0;; 2.0]])
    singleton_matrix = BlockDiagonal([A,B,[1.0;;]])

    # deconstruction
    @test Matrix(B1) == [A zeros(size(A, 1), size(B, 2)); zeros(size(B, 1), size(A, 2)) B]

    # size
    @test size(B1) == size(A) .+ size(B)
    @test size(B1, 1) == size(A, 1) .+ size(B, 1)
    @test size(B1, 2) == size(A, 2) .+ size(B, 2)
    @test length(B1) == (5+3)^2

    # equality
    @test B1 == B1
    @test B1 == B2
    @test B1 !== B3

    # matrix operations
    @test inv(B1) == BlockDiagonal([inv(A), inv(B)])
    @test det(B1) == det(A) * det(B)
    @test tr(B1) == tr(A) + tr(B)
    @test B1' == BlockDiagonal([A', B'])
    @test eltype(B1) == Float64

    # matrix-vector operations
    v = randn(size(B1, 1))
    @test Matrix(B1) * v ≈ B1 * v
    @test B1 \ v ≈ Matrix(B1) \ v
end
