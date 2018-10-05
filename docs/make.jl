using Documenter, DarkTracks

makedocs(
    modules = [DarkTracks],
    format = :html,
    sitename = "DarkTracks.jl",
    pages = Any["index.md"]
)

deploydocs(
    repo = "github.com/yakir12/DarkTracks.jl.git",
    target = "build",
    julia = "1.0",
    deps = nothing,
    make = nothing,
)
