module CuboidGrids

	using LinearAlgebraicRepresentation
	using Common

	using NearestNeighbors
	using DataStructures
	using IntervalTrees
	using Triangle
	using SparseArrays
	using LinearAlgebra
	using Distributed

	using ViewerGL
	GL = ViewerGL

	"""
		Points = Array{Number,2}

	Alias declation of LAR-specific data structure.
	Dense `Array{Number,2,1}` ``M x N`` to store the position of *vertices* (0-cells)
	of a *cellular complex*. The number of rows ``M`` is the dimension
	of the embedding space. The number of columns ``N`` is the number of vertices.
	"""
	const Points = Matrix


	"""
		Cells = Array{Array{Int,1},1}

	Alias declation of LAR-specific data structure.
	Dense `Array` to store the indices of vertices of `P-cells`
	of a cellular complex.
	The linear space of `P-chains` is generated by `Cells` as a basis.
	Simplicial `P-chains` have ``P+1`` vertex indices for `cell` element in `Cells` array.
	Cuboidal `P-chains` have ``2^P`` vertex indices for `cell` element in `Cells` array.
	Other types of chain spaces may have different numbers of vertex indices for `cell`
	element in `Cells` array.
	"""
	const Cells = Array{Array{Int,1},1}


	const Cell = SparseVector{Int8, Int}


	"""
		Chain = SparseArrays.SparseVector{Int8,Int}

	Alias declation of LAR-specific data structure.
	Binary `SparseVector` to store the coordinates of a `chain` of `N-cells`. It is
	`nnz=1` with `value=1` for the coordinates of an *elementary N-chain*, constituted by
	a single *N-chain*.
	"""
	const Chain = SparseArrays.SparseVector{Int8,Int}


	"""
		ChainOp = SparseArrays.SparseMatrixCSC{Int8,Int}

	Alias declation of LAR-specific data structure.
	`SparseMatrix` in *Compressed Sparse Column* format, contains the coordinate
	representation of an operator between linear spaces of `P-chains`.
	Operators ``P-Boundary : P-Chain -> (P-1)-Chain``
	and ``P-Coboundary : P-Chain -> (P+1)-Chain`` are typically stored as
	`ChainOp` with elements in ``{-1,0,1}`` or in ``{0,1}``, for
	*signed* and *unsigned* operators, respectively.
	"""
	const ChainOp = SparseArrays.SparseMatrixCSC{Int8,Int}


	"""
		ChainComplex = Array{ChainOp,1}

	Alias declation of LAR-specific data structure. It is a
	1-dimensional `Array` of `ChainOp` that provides storage for either the
	*chain of boundaries* (from `D` to `0`) or the transposed *chain of coboundaries*
	(from `0` to `D`), with `D` the dimension of the embedding space, which may be either
	``R^2`` or ``R^3``.
	"""
	const ChainComplex = Array{ChainOp,1}


	"""
		LARmodel = Tuple{Points,Array{Cells,1}}

	Alias declation of LAR-specific data structure.
	`LARmodel` is a pair (*Geometry*, *Topology*), where *Geometry* is stored as
	`Points`, and *Topology* is stored as `Array` of `Cells`. The number of `Cells`
	values may vary from `1` to `N+1`.
	"""
	const LARmodel = Tuple{Points,Array{Cells,1}}


	"""
		LAR = Union{ Tuple{Points, Cells},Tuple{Points, Cells, Cells} }

	Alias declation of LAR-specific data structure.
	`LAR` is a pair (*Geometry*, *Topology*), where *Geometry* is stored as
	`Points`, and *Topology* is stored as `Cells`.
	"""
	const LAR = Union{ Tuple{Points, Cells},Tuple{Points, Cells, Cells} }

	"""
    binaryRange(n)

	Generate the first `n` binary numbers in string padded for max `2^n` length
	"""
	function binaryRange(n)
		return string.(range(0, length=2^n), base=2, pad=n)
	end



	

	#funzione presa da mapper.jl per favorire l'esecuzione
	"""
	approxVal(PRECISION)(value)

	Transform the float `value` to get a `PRECISION` number of significant digits.
	"""
	function approxVal(PRECISION)
	function approxVal0(value)
		out = round(value, digits=PRECISION)
		if out == -0.0
			out = 0.0
		end
		return out
	end
	return approxVal0
	end





	#Funzioni prese da example_vooxellization per snellire i codici di esecuzione del package o
	"""
	 CV2FV( Array{Int64} ) Array{Int64}
	 Return the vertices cells array tranformed to a vertices faces array
	"""
	function CV2FV( v::Array{Int64} )
		faces = [
			[v[1], v[2], v[3], v[4]], [v[5], v[6], v[7], v[8]],
			[v[1], v[2], v[5], v[6]],	[v[3], v[4], v[7], v[8]],
			[v[1], v[3], v[5], v[7]], [v[2], v[4], v[6], v[8]]]
	end
	
	"""
	CV2EV( Array{Int64} ) Array{Int64}
	Return the vertices cells array tranformed to an vertices edges array
	"""
	function CV2EV( v::Array{Int64} )
		edges = [
			[v[1], v[2]], [v[3], v[4]], [v[5], v[6]], [v[7], v[8]], [v[1], v[3]], [v[2], v[4]],
			[v[5], v[7]], [v[6], v[8]], [v[1], v[5]], [v[2], v[6]], [v[3], v[7]], [v[4], v[8]]]
	end
	
	"""
	K( Array{Int64} )
	Return the sparse matrix built with the passed array
	"""
	function K( CV )	#costruisce e ritorna una matrice sparsa a partire dalla collezione passata(matrice dei vertici, degli edges, delle facce, etc)
		I = vcat( [ [k for h in CV[k]] for k=1:length(CV) ]...) #righe
		J = vcat(CV...)											#colonne
		Vals = [1 for k=1:length(I)]							#valori della matrice
		return sparse(I,J,Vals)									#costruzione della matrice sparsa
	end

	"""
	VEF( Array{Float64,2}, Array{Int64})
	Given the vertices array and the vertex cells array, return the vertex faces and edges array
	"""
	#Threads.@spawn 
	function VEF( V::Array{Float64,2}, CV::Array{Int64})
		VV = [[v] for v=1:size(V,2)]
		FV = convert(Array{Array{Int64,1},1}, collect(Set(cat(pmap(CV2FV,CV))))) #verts faces
		EV = convert(Array{Array{Int64,1},1}, collect(Set(cat(pmap(CV2EV,CV))))) #verts edges
		return VV, FV, EV
	end


	"""
	Thanks to the K function, build and return the sparse matrix for vertex, edges, faces and cells array
	"""
#Cotruzine delle varie matrici tramite la funzione K per la visualizzazione delle facce interne/esterne
	Threads.@spawn function Mats( VV, FV, EV, CV)
		M_0 = K(VV)
		M_1 = K(EV)
		M_2 = K(FV)
		M_3 = K(CV)
		return M_0, M_1, M_2, M_3
	end

	#used for testing
	function executeShowVoxels(shape )
		V, CV = Lar.cuboidGrid(shape)
		#GL.VIEW([GL.GLLar2gl(V,CV)])
	end
		
	function callExample()
	end

   include("./largrid.jl")
   include("./struct.jl")

end
