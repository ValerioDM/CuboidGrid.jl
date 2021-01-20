using DataStructures
using Distributed
using LinearAlgebraicRepresentation; Lar = LinearAlgebraicRepresentation

#=
using CuboidGrids; Lar = CuboidGrids
mod1D = Lar.grid(repeat([.1,-.1],outer=5)...)

using ViewerGL; GL = ViewerGL

GL.VIEW([ GL.GLFrame2, GL.GLGrid(mod1D..., GL.COLORS[1],1) ])

mod3D = Lar.INSR(Lar.larModelProduct)([mod1D,mod1D,mod1D])

GL.VIEW([ GL.GLFrame2, GL.GLPol(mod3D..., GL.COLORS[1],1) ])
=#

map(x->x*2, [1,2,3])
reduce(*, [2;3;4])

function random3cells(shape,npoints)
	pointcloud = rand(3,npoints).*shape
	grid = DataStructures.DefaultDict{Array{Int,1},Int}(0)

	for k = 1:size(pointcloud,2)
		v = map(Int∘trunc,pointcloud[:,k])
		if grid[v] == 0 # do not exists
			grid[v] = 1
		else
			grid[v] += 1
		end
	end

	out = Array{Lar.Struct,1}()
	for (k,v) in grid
		V = k .+ [
		 0.0  0.0  0.0  0.0  1.0  1.0  1.0  1.0;
		 0.0  0.0  1.0  1.0  0.0  0.0  1.0  1.0;
		 0.0  1.0  0.0  1.0  0.0  1.0  0.0  1.0]
		cell = (V,[[1,2,3,4,5,6,7,8]])
		push!(out, Lar.Struct([cell]))
	end
	out = Lar.Struct( out )
	V,CV = Lar.struct2lar(out)
    return pointcloud,V,CV
end

pointcloud,V,CV = random3cells([2,2,2],4_000)
println("== stampa di V ======================================")
println(V)
println("== stampa di CV ======================================")
println(CV)

println("========================================")
println("========================================")
V,CV = Lar.cuboidGrid([2,2,2])
println("== stampa di V ======================================")
println(V)
println("== stampa di CV ======================================")
println(CV)
#pmap(f, random3cells([2,2,2],4_000); distributed=true, batch_size=1, on_error=nothing, retry_delays=[], retry_check=nothing) -> collection


#=
pointcloud,V,CV = random3cells([1,1,1],10)
0.0 0.0 0.0 0.0 1.0 1.0 1.0 1.0;
0.0 0.0 1.0 1.0 0.0 0.0 1.0 1.0;
0.0 1.0 0.0 1.0 0.0 1.0 0.0 1.0
=#