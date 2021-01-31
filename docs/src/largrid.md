# largrid

This file is the heart of the project. Itit contains the function used for the voxellization process.
The parallelization has been implemented intially with the pmap function.
Another attempt was to diassamble the the functions and parallelize them with the @thread macro. This attempt was almost istantly discarded because it would mean make the same function more complicated, adding computational time.
The whole process start from the call of the *cuboidGrid* function, which only need the shape of the data that is wanted to be voxellized. From the shape will be extracted the vertices array and the cells array.

## Function list
```@docs
CuboidGrids.larVertProd
```

```@docs
CuboidGrids.larImageVerts
```

```@docs
CuboidGrids.filterByOrder
```

```@docs
CuboidGrids.larCellProd
```

```@docs
CuboidGrids.larGridSkeleton
```

```@docs
CuboidGrids.cuboidGrid
```