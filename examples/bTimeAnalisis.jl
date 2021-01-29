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

println("=======================================================================")
println("@btime for data visualization: ")
    @btime Lar.executeShowVoxels([10,20,10])
println("-----------------------------------------------------------------------")
println("@btime for data visualization(with map maethods): ")
    @btime Lar.callExample()


println("=======================================================================")
println("@btime for data preparation before visualization(with pmap maethods): ")
    PAR1,PAR2 = @btime Lar.cuboidGrid([10,20,10])
    #PAR1,PAR2 = @btime Lar.cuboidGridT([10,20,10])
println("-----------------------------------------------------------------------")
println("@btime for data preparation before visualization(with map maethods): ")
    PAR1,PAR2 = @btime OlLar.cuboidGrid([10,20,10])

println("=======================================================================")
println("...Adding pmap does not improve the performance in cuboidGrid")
println("To understand why, let's see the single sub functions with the same input")

println("=======================================================================")
println("@btime for larImageVerts(with pmap maethods): ")
    PAR1 = @btime Lar.larImageVerts([10,20,10])
   # PAR1 = @btime Lar.larImageVertsT([10,20,10])
println("-----------------------------------------------------------------------")
println("@btime for larImageVerts(with map maethods): ")
    PAR1 = @btime OlLar.larImageVerts([10,20,10])

println("=======================================================================")
println("@btime for larGridSkeleton(with map maethods): ")
    PAR1 = @btime Lar.larGridSkeleton([10,20,10])
    #PAR1 = @btime Lar.larGridSkeletonT([10,20,10])
println("-----------------------------------------------------------------------")
println("@btime for larGridSkeleton(with map maethods): ")
    PAR1 = @btime OlLar.larGridSkeleton([10,20,10])

