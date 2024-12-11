!!! note "Reviewers Notice"
    I have made a potentially fatal "executive decision" when writing this book.
    Simply put, I don't want a full chapter on Julia as a language.
    Rather, I will sprinkle in topics as they become relevant to the greater discussion on GPU computing.
    I am not entirely convinced this is the right approach, so if you think a full chapter on Julia would be worthwhile, let me know!
    
    On that note, I have been intending to write another book, [Intro.jl](http://www.leioslabs.com/Intro.jl/dev/), a simple guide to introduce new programmers to Julia.
    It could act as a sister-guide to this one.
    GPU questions would be answered in this book.
    Julia questions would be answered in the other one.
    If you put them together and someone with no programming experience could be up and running with GPU computing simply by completing all the exercises.
    
    That said, there are other people who could probably write an introduction to Julia book better than I could, so I am not convinced I should write *Intro.jl* either.
    Let me know if you think I am going too quickly through the Julia discussion in this book.
    If so, then Intro.jl becomes more worthwhile as a standalone book.
    We can then "hit the ground running" with GPU computing here.

# Julia: A Chainsaw of a Language

In casual conversation, the word "simple" is often used interchangeably with the phrase "easy to use"; however, when it comes to tools that we use on a daily basis, the two concepts might actually be opposite of each other.
For example, let's say we are asked to cut down a forest and are given the choice of two tools: either a chainsaw or an axe [^1]
Clearly, the axe is simpler to use.
We just need to pick it up, point the bladed edge towards a tree, and chop.
The chainsaw, on the other hand, requires a bit more knowledge on how to power it, keep the chains lubricated, and ensure the safety of ourselves and everyone around us.
Even with this added complexity, I think that we can all agree that the chainsaw is a much better tool for this job.
In short: for this problem, the axe is *simpler*, but the chainsaw is *easier to use*.

[^1]: For the record, I am not advocating that you *actually* cut down a forest. This discussion is purely hypothetical.

It's important to make this distinction with software as well.
Often times, the easiest software to use is also the most complicated under-the-hood.
Simultaneously, the simplest software is the hardest to use in practice.
Take C for example.
It is a relatively simple programming language -- so simple, in fact, that it can be easily called from most other high-level languages.
It's also blazingly fast -- usually the fastest language available for most tasks.
So why not just code directly in C?
Because it's *too* simple.
It's missing a lot of the features modern-day users want: plotting, dynamic recompilation, safe memory management, and so on.

How is this all related to Julia?
Well, Julia is the easiest language I have ever used, which means that it often feels incredibly complicated under-the-hood.

It is a chainsaw, and it's important to keep that in mind throughout the rest of this book.

## Installing Julia
