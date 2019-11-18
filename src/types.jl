abstract type Operation end
abstract type ArrayOperation <: Operation end
abstract type ImageOperation <: Operation end
abstract type AffineOperation <: ImageOperation end
abstract type Pipeline end
const AbstractPipeline = Union{Pipeline,Tuple{Vararg{Operation}}}
