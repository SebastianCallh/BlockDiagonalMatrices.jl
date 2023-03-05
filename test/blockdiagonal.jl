@testset "block diagonal" begin

    # construction
    A = rand(5, 5)
    B = rand(3, 3)

    B1 = BlockDiagonal(A, B)
    B2 = BlockDiagonal([A, B])
    B3 = BlockDiagonal([A, [1.0;; 2.0]])

    # deconstruction
    @test Matrix(B1) == [A zeros(size(A, 1), size(B, 2)); zeros(size(B, 1), size(A, 2)) B]


    # equality
    @test B1 == B1
    @test B1 == B2
    @test B1 !== B3
end
