using Documentation
using CuboidGrids

Documenter.makedocs(
    format = Documenter.HTML(
        prettyurl = get(ENV, "CI", nothing)==true
    ),
    sitename = "CuboidGrids.jl",
    pages = [
        "Home"=> "index.md",
        "CuboidGrids"=> "CuboidGrids.md",
        "largrid.jl"=> "largrid.md"
    ]
)
