using LinearAlgebraicRepresentation
using Profile
using BenchmarkTools

using NearestNeighbors
using DataStructures
using IntervalTrees
using Triangle
using SparseArrays
using LinearAlgebra
using Distributed

#source folder
CuboidGrids: "C:/Users/UNIEURO/.julia/dev/CuboidGrids"

println("=======================================================================")
println("@btime for largrid: ")
LARcuboidGrids = @btime LinearAlgebraicRepresentation.largrid($LARcuboidGrids)



println("=======================================================================")
println("@btime for CuboidGrids: ")
LARcuboidGrids = @btime LinearAlgebraicRepresentation.largrid($LARcuboidGrids)



Gl.VIEW(
    [
        Visualization.points_color_from_rgb(PPC.coordinates, PPC.rgbs)
    ]
)
Gl.VIEW(
    [
        Visualization.points_color_from_rgb(FMPC.coordinates, FMPC.rgbs)
    ]
)
