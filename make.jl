using Documenter

makedocs(
    sitename="GPU Kernel Handbook",
    authors="James Schloss (Leios)",
    pages = [
        "Welcome" => "index.md",
        "Introduction" => "content/intro.md",
    ],
)

deploydocs(;
    repo="github.com/leios/gpu-handbook",
    versions = nothing,
)
