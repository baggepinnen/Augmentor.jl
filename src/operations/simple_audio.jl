# TODO: implement methods for n-dim arrays

"""
    Amplify <: Augmentor.ArrayOperation

Description
--------------

Amplifies a signal


Usage
--------------

    Amplify(p)

Arguments
--------------

- **`p::Number`** : Amplification factor

Examples
--------------

```jldoctest
julia> using Augmentor

julia> sig = [1,2,3,4]
4-element Array{Int64,1}:
 1
 2
 3
 4

julia> sig_new = augment(sig, Amplify(-1))
4-element Array{Int64,1}:
 -1
 -2
 -3
 -4
```
"""
struct Amplify{T<:Number} <: Augmentor.ArrayOperation
    p::T
end

@inline supports_stepview(::Type{Amplify}) = false
@inline supports_lazy(::Type{Amplify}) = true

applyeager(op::Amplify, input::AbstractArray, param) = plain_array(op.p .* input)

applylazy(op::Amplify, input::AbstractArray, param) = mappedarray(x->op.p*x, input)

function showconstruction(io::IO, op::Amplify)
    print(io, typeof(op).name.name, "($(op.p))")
end

function Base.show(io::IO, op::Amplify)
    if get(io, :compact, false)
        print(io, "Amplify signal")
    else
        print(io, "Augmentor.")
        showconstruction(io, op)
    end
end
