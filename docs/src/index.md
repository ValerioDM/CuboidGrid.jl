#Aim of the progect

##CuboidGrids is the result of the work of the pre-existing package [LinearAlgebraicRepresetation](https://github.com/cvdlab/LinearAlgebraicRepresentation.jl).

The aim of the project is to optimize the package for the voxellization, using parallel computing techniques such as multithrerading and/or sitribution.
The package contains 3 files, CuboidGrids,jl for the dipendences, struct.jl and largrid.jl.

Voxellization is a process by which specific data structure are made. These data structure represent informations in a way that can be visualized in a 2- ore 3-dimensional render, thanks to the help of other package.
For the voxellixaion is such a "hidden" concept without the graphic result, an example file has been given for the project. This file contain function for the data processing before the visualization, which are introducedin the new package as well.
The parallelization has been implemented in several ways such as the *@spawn* macro, the *@Threads* macro or the *pmap* function. Unfotunally, no improvement has been analized. Even if the number of threads is set right, as well as the numer of workers for the distribution, the result of the analisis made with the *btime* macro shows not only no improvement at all, but a small downgrade of the performance, as showed below:

![Log1.jpg](https://www.dropbox.com/home/Dillinger/_images?preview=btimeLog1.jpg)

![Log2.jpg](https://www.dropbox.com/home/Dillinger/_images?preview=btimeLog2.jpg)