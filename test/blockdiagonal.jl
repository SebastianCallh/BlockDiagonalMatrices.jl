@testset "block diagonal" begin

    # construction
    M1 = rand(1, 1)
    M2 = rand(1, 1)

    B1 = BlockDiagonal(M1, M2)
    B2 = BlockDiagonal([M1, M2])
    B3 = BlockDiagonal([M1, [1.0;; 2.0]])

    # equality
    @test B1 == B1
    @test B1 == B2
    @test B1 !== B3
end
