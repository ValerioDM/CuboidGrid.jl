using LinearAlgebraicRepresentation
using CuboidGrids
using Profile
using BenchmarkTools

using NearestNeighbors
using DataStructures
using IntervalTrees
using Triangle
using SparseArrays
using LinearAlgebra
using Distributed

Lar = CuboidGrids
OlLar = LinearAlgebraicRepresentation
#source folder
#cuboidGrids: "C:/Users/UNIEURO/.julia/dev/CuboidGrids"

println("=======================================================================")
println("@btime for data preparation before visualization(with pmap maethods): ")
    PAR1,PAR2 = @btime Lar.cuboidGrid([10,20,10])



println("=======================================================================")
println("@btime for data preparation before visualization(with map maethods): ")
PAR1,PAR2 = @btime OlLar.cuboidGrid([10,20,10])



