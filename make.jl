using Documenter

makedocs(
    sitename="GPU Kernel Handbook",
    authors="James Schloss (Leios)",
    pages = [
        "Welcome" => "index.md",
        "Reviewer Guidelines" => "content/reviewers.md",
        "About the Author" => "content/about_me.md",
        "Introduction" => "content/intro.md",
        "All the Ways to GPU" => "content/abstractions.md",
    ],
)

deploydocs(;
    repo="github.com/leios/gpu-handbook",
    versions = nothing,
)
