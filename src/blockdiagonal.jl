struct BlockDiagonal{T<:AbstractMatrix}
    blocks::Vector{T}
end

BlockDiagonal(mats...) = BlockDiagonal(collect(mats))

_dim_size(xs, dim) = mapreduce(x -> size(x, dim), +, xs)
Base.size(A::BlockDiagonal) = (_dim_size(A.blocks, 1), _dim_size(A.blocks, 2))
Base.size(A::BlockDiagonal, dim) = _dim_size(A.blocks, dim)

Base.:(==)(A::BlockDiagonal, B::BlockDiagonal) = begin
    size(A) == size(B) || return false
    mapreduce(x -> x[1] == x[2], &, zip(A.blocks, B.blocks))
end

LinearAlgebra.inv(A::BlockDiagonal) = BlockDiagonal(map(inv, A.blocks))

LinearAlgebra.Matrix(A::BlockDiagonal) = begin
    B = zeros(size(A))
    offset = CartesianIndex(0, 0)
    for b in A.blocks
        for i in CartesianIndices(b)
            B[offset+i] = b[i]
        end
        offset += CartesianIndex(size(b, 1), size(b, 2))
    end

    return B
end
