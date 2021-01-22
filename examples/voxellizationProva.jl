"""si basa sul file voxellizationProva ma usa il mio package invece di LinearAlgebraicAlgebra
e verrà usato per l'analisi delle prestazioni una volta implementata la parallellizazzione"""

using CuboidGrids, SparseArrays, DataStructures
using Distributed
Lar = CuboidGrids

using ViewerGL
GL = ViewerGL

# Dati da larGrid


function CV2FV( v::Array{Int64} )
	faces = [
		[v[1], v[2], v[3], v[4]], [v[5], v[6], v[7], v[8]],
		[v[1], v[2], v[5], v[6]],	[v[3], v[4], v[7], v[8]],
		[v[1], v[3], v[5], v[7]], [v[2], v[4], v[6], v[8]]]
end

function CV2EV( v::Array{Int64} )
	edges = [
		[v[1], v[2]], [v[3], v[4]], [v[5], v[6]], [v[7], v[8]], [v[1], v[3]], [v[2], v[4]],
		[v[5], v[7]], [v[6], v[8]], [v[1], v[5]], [v[2], v[6]], [v[3], v[7]], [v[4], v[8]]]
end

function K( CV )	#costruisce e ritorna una matrice sparsa a partire dalla collezione passata(matrice dei vertici, degli edges, delle facce, etc)
	I = vcat( [ [k for h in CV[k]] for k=1:length(CV) ]...) #righe
	J = vcat(CV...)											#colonne
	Vals = [1 for k=1:length(I)]							#valori della matrice
	return sparse(I,J,Vals)									#costruzione della matrice sparsa
end

V,CV = Lar.cuboidGrid([10,20,10])
#pointcloud,V,CV = random3cells([40,20,10],4_000)

VV = [[v] for v=1:size(V,2)]
FV = convert(Array{Array{Int64,1},1}, collect(Set(cat(pmap(CV2FV,CV))))) #verts faces
EV = convert(Array{Array{Int64,1},1}, collect(Set(cat(pmap(CV2EV,CV))))) #verts edges

#Cotruzine delle varie matrici tramite la funzione K
M_0 = K(VV)
M_1 = K(EV)
M_2 = K(FV)
M_3 = K(CV)


∂_1 = M_0 * M_1'
∂_2 = (M_1 * M_2') .÷ 2 #	.÷ sum(M_1,dims=2)
s = sum(M_2,dims=2)
∂_3 = (M_2 * M_3')
∂_3 = ∂_3 ./	s
∂_3 = ∂_3 .÷ 1	#	.÷ sum(M_2,dims=2)

S2 = sum(∂_3,dims=2)
inner = [k for k=1:length(S2) if S2[k]==2]
outer = setdiff(collect(1:length(FV)), inner)

# point cloud
#GL.VIEW([GL.GLPoints(convert(Lar.Points,pointcloud'), GL.COLORS[1])])

# voxels
GL.VIEW([GL.GLLar2gl(V,CV)])

#=
# edges
GL.VIEW([ GL.GLGrid(V,EV,GL.Point4d(1,1,1,1))
          GL.GLAxis(GL.Point3d(-1,-1,-1),GL.Point3d(1,1,1)) ]);

# inner faces
GL.VIEW([ GL.GLGrid(V,FV[inner],GL.Point4d(1,1,1,1))
          GL.GLAxis(GL.Point3d(-1,-1,-1),GL.Point3d(1,1,1)) ]);

# outer faces
GL.VIEW([ GL.GLGrid(V,FV[outer],GL.Point4d(1,1,1,1))
          GL.GLAxis(GL.Point3d(-1,-1,-1),GL.Point3d(1,1,1)) ]);

=#

#-------------------------------------------------------------------------------------------


V,CV = Lar.cuboidGrid([5,20,10])
#pointcloud,V,CV = random3cells([40,20,10],4_000)

VV = [[v] for v=1:size(V,2)]
FV = convert(Array{Array{Int64,1},1}, collect(Set(cat(pmap(CV2FV,CV)))))
EV = convert(Array{Array{Int64,1},1}, collect(Set(cat(pmap(CV2EV,CV)))))

M_0 = K(VV)
M_1 = K(EV)
M_2 = K(FV)
M_3 = K(CV)

∂_1 = M_0 * M_1'
∂_2 = (M_1 * M_2') .÷ 2 #	.÷ sum(M_1,dims=2)
s = sum(M_2,dims=2)
∂_3 = (M_2 * M_3')
∂_3 = ∂_3 ./	s
∂_3 = ∂_3 .÷ 1	#	.÷ sum(M_2,dims=2)

S2 = sum(∂_3,dims=2)
inner = [k for k=1:length(S2) if S2[k]==2]
outer = setdiff(collect(1:length(FV)), inner)

# point cloud
#GL.VIEW([GL.GLPoints(convert(Lar.Points,pointcloud'), GL.COLORS[1])])

# voxels
GL.VIEW([GL.GLLar2gl(V,CV)])
