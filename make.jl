using Documenter

makedocs(
    sitename="GPU Programming Handbook",
    authors="James Schloss (Leios)",
    pages = [
        "General Information" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/leios/gpu-handbook",
    versions = nothing,
)
