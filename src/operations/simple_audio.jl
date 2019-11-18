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


# ---------------------------------------------------------------------


"""
    LinearFilter <: Augmentor.ArrayOperation

Description
--------------

Filters a signal using a linear filter


Usage
--------------

    LinearFilter()

Arguments
--------------

- **`p::Number`** : Amplification factor

Examples
--------------

```jldoctest
julia> using Augmentor, DSP

julia> filter = LinearFilter(digitalfilter(Lowpass(0.4), Butterworth(2)))
Augmentor.LinearFilter(ZeroPoleGain{Complex{Float64},Complex{Float64},Float64}(Complex{Float64}[-1.0 + 0.0im, -1.0 + 0.0im], Complex{Float64}[0.18476368867562076 + 0.40209214367208346im, 0.18476368867562076 - 0.40209214367208346im], 0.20657208382614792))

julia> sig = [0,1,0,1,0,1,0,1]
8-element Array{Int64,1}:
 0
 1
 0
 1
 0
 1
 0
 1

julia> sig_new = augment(sig, filter)'
1×8 Adjoint{Float64,Array{Float64,1}}:
 0.0  0.206572  0.489478  0.55357  0.521856  0.497587  0.494828  0.498562
```
"""
struct LinearFilter{T<:DSP.FilterCoefficients} <: Augmentor.ArrayOperation
    filter::T
end

@inline supports_stepview(::Type{LinearFilter}) = false
@inline supports_lazy(::Type{LinearFilter}) = false

applyeager(op::LinearFilter, input::AbstractArray, param) = plain_array(filt(op.filter, input))


function showconstruction(io::IO, op::LinearFilter)
    print(io, typeof(op).name.name, "($(op.filter))")
end

function Base.show(io::IO, op::LinearFilter)
    if get(io, :compact, false)
        print(io, "LinearFilter signal")
    else
        print(io, "Augmentor.")
        showconstruction(io, op)
    end
end
