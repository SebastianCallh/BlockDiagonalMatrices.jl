struct BlockDiagonal{T<:AbstractMatrix, F <: Factorization}
    blocks::Vector{T}
    factors::Vector{F}

    BlockDiagonal(blocks) = let
        factors = factorize.(blocks)
        new{eltype(blocks), eltype(factors)}(blocks, factors)
    end
end


_dim_size(xs, dim) = mapreduce(x -> size(x, dim), +, xs)
Base.size(A::BlockDiagonal) = (_dim_size(A.blocks, 1), _dim_size(A.blocks, 2))
Base.size(A::BlockDiagonal, dim) = _dim_size(A.blocks, dim)
Base.length(A::BlockDiagonal) = size(A, 1) * size(A, 2)

Base.:(==)(A::BlockDiagonal, B::BlockDiagonal) = begin
    size(A) == size(B) || return false
    mapreduce(x -> x[1] == x[2], &, zip(A.blocks, B.blocks))
end

Base.:(*)(A::BlockDiagonal, v::AbstractVector) = begin
    u = typeof(v)(undef, length(v))
    offset = 1
    for b in A.blocks
        n = offset + size(b, 1) - 1
        u[offset:n] .= b * view(v, offset:n)
        offset += size(b, 1)
    end

    return u
end

LinearAlgebra.det(A::BlockDiagonal) = mapreduce(det, *, A.blocks)

LinearAlgebra.tr(A::BlockDiagonal) = mapreduce(tr, +, A.blocks)

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

LinearAlgebra.:\(A::BlockDiagonal, v::AbstractVector) = begin
    u = Vector{eltype(v)}(undef, length(v))
    i = 1
    for f in A.factors
        n = size(f, 1)
        ldiv!(view(u, i:i+n-1), f, view(v, i:i+n-1))
        i += n
    end

    return u
end
