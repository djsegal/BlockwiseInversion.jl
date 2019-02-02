using Documenter, BlockwiseInversion

makedocs(;
    modules=[BlockwiseInversion],
    format=Documenter.HTML(),
    pages=[
        "Home" => "index.md",
    ],
    repo="https://github.com/djsegal/BlockwiseInversion.jl/blob/{commit}{path}#L{line}",
    sitename="BlockwiseInversion.jl",
    authors="djsegal",
    assets=[],
)

deploydocs(;
    repo="github.com/djsegal/BlockwiseInversion.jl",
)
