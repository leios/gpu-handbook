using Documenter

makedocs(
    sitename="GPU Programming Handbook",
    authors="James Schloss (Leios)",
    pages = [
        "Publication Details" => "index.md",
        "About This Book" => "content/intro.md",
        "Language Doesn't Matter" => "content/language.md",
    ],
)

deploydocs(;
    repo="github.com/leios/gpu-handbook",
    versions = nothing,
)
