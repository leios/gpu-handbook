using Documenter

makedocs(
    sitename="GPU Kernel Handbook",
    authors="James Schloss (Leios)",
    pages = [
        "Publication Details" => "index.md",
        "Language Doesn't Matter" => "content/language.md",
    ],
)

deploydocs(;
    repo="github.com/leios/gpu-handbook",
    versions = nothing,
)
