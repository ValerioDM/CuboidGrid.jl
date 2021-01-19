
using CuboidGrids; Lar = CuboidGrids

mod1D = Lar.grid(repeat([.1,-.1],outer=5)...)

using ViewerGL; GL = ViewerGL

GL.VIEW([ GL.GLFrame2, GL.GLGrid(mod1D..., GL.COLORS[1],1) ])

mod3D = Lar.INSR(Lar.larModelProduct)([mod1D,mod1D,mod1D])

GL.VIEW([ GL.GLFrame2, GL.GLPol(mod3D..., GL.COLORS[1],1) ])