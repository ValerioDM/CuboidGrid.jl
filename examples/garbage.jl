""" Lar = LinearAlgebraicRepresentation """



"""
function grid(sequence...)
	sequence = collect(sequence)
	cursor,points,hulls= (0,[[0.]],[])
	for value in sequence
		points = append!(points, [[cursor + abs(value)]])
		if value>=0
			append!(hulls,[[length(points)-1,length(points)]])
		end
	  cursor += abs(value)
	end
	V = convert(Lar.Points, [p[1] for p in points]')
	EV = convert(Lar.Cells,hulls)
	return V,EV
end
const q = grid
"""