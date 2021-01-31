using Documenter
using CuboidGrids

Documenter.makedocs(
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing)== "true"
    ),
    sitename = "CuboidGrids.jl",
    pages = [
        "Home"=> "index.md",
        "CuboidGrids"=> "CuboidGrids.md",
        "largrid.jl"=> "largrid.md"
    ]
)
