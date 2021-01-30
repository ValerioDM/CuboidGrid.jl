using DataStructures
using Distributed
using CuboidGrids; Lar = CuboidGrids

using Random
using BenchmarkTools
using Base.Threads

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

#=il problema svolto con mapreduce
    mapreduce(x-> rem(33333331, x), max, 1:16666665)    => 11111109
  diventa:  
@parallel max for x in 1:16666665
    rem(33333331, x)                                    => 11111109
end     

io devo fare:
@parallel <risultato ottenuto?> for x in <collezizone>
    <funzione da applicare>  (si fa su funzioni che hanno bisogno di un solo parametro?)
end
=#                    
           
function serial_add()
	s=0.0
	for i = 1:100000
		s=s+Random.randn()
	end
	return s
end

function parallel_add()
	return @distributed (+) for i=1:100000
	Random.randn()
	end
end

@btime serial_add()
@btime parallel_add()

@threads for i in 1:nthreads()
	a[threadid()] = threadid() 
	end