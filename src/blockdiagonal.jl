struct BlockDiagonal{T<:AbstractMatrix}
    blocks::Vector{T}
end

BlockDiagonal(mats...) = BlockDiagonal(collect(mats))

_dim_size(xs, dim) = mapreduce(x -> size(x, dim), +, xs)
Base.size(m::BlockDiagonal) = (_dim_size(m.blocks, 1), _dim_size(m.blocks, 2))
Base.size(m::BlockDiagonal, dim) = _dim_size(m.blocks, dim)

Base.:(==)(m1::BlockDiagonal, m2::BlockDiagonal) = begin
    size(m1) == size(m2) || return false
    mapreduce(x -> x[1] == x[2], &, zip(m1.blocks, m2.blocks))
end
