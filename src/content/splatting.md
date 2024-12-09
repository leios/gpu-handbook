## The Jank

Yeah.
I'm going to come out and say it.
No matter what language or interface you use for GPU programming in 2024, you will probably find yourself at least a little disappointed.
They all feel a little rough, lacking the polish that programmers are used to nowadays.
It is downright impossible to describe this problem fully.
GPU functions look odd when compared to their CPU counterparts.
Also, many common programming techniques simply don't work on the GPU.
Way back.

In general, a "language" is a method of communication between two (or more) individuals.
A "*programming* language" is a method to communicate with a computer.
Programming languages typically require a translation (compilation) step to transform the user-submitted code to something that the computer can understand.

Nowadays, many languages will have multiple compilation steps, and will first lower the user code into a Lower-Level Intermediate Representation (LLIR) before then compiling down to machine code.
The core advantage here is that the lowered code can then be compiled to different hardware.
Simply put, the final set of instructions for AMD and Intel machines might be different, but the intermediate representation can be shared.

Many languages (Julia, Rust, and even C sometimes) will compile down to the same intermediate representation known as LLVM (which stands for Lower-Level Virtual Machine).
This means that as long as the conversion from Julia to LLVM is done well, it should be (roughly) the same speed as C.

In a sense, GPU programming is not as straightforward.
Until now, I have been careful not to call the GPU protocols "languages," because they usually take regular languages (C, Python, Julia, Rust, etc) and extend the functionality to run on a GPU.
For this reason, I have instead called them "interfaces," and you will regularly see them called Application Programming Interfaces (APIs) when people talk about them in the "real" world.
It is important to note that because the GPU interfaces target the GPU (and not the CPU), the all boil down to a *different* intermediate representation than for the CPU.

That said, some of the GPU interfaces will still compile down to something *like* LLVM that has been modified for the GPU (NVPTX for CUDA, for example).
Others compile down to another intermediate representation entirely.
For example, OpenCL (the Open Compute Language) and Vulkan (a graphics interface) both compile down to something called SPIRV.

Now, I hear what you are saying, "That's great! We've got ourselves an open standard (SPIRV) that has unified both graphics and compute! Isn't that a core issue we already talked about in this chapter? Surely all the other interfaces will rally behind it, right?"

Ok. Good question.
It's impossible to answer without diving (at least a little bit) into the weeds.

Simply put, reality is not that simple.
The problem with SPIRV is that it's a bit too broad.
Unlike LLVM, which is the same no matter what language is using it (Julia, Rust, C), SPIRV has two distinctly different implementations for graphics and compute.
That is to say that the SPIRV implementation for OpenCL (a compute language) is not the same as the SPIRV implementation for Vulkan (a graphics interface).

This is honestly maddening!
What this means is that you cannot use compute functions written in OpenCL in a graphics language like Vulkan even though they both use SPIRV!
Though it is entirely possible to work on the LLVM level and create applications that work across multiple CPU languages, the same is not true for GPU languages -- not only because not all compute languages boil down to SPIRV, but SPIRV is not always the *right* SPIRV for specific uses.

This little rant has a valuable piece of information hidden just below the surface.
The state of GPU computing in 2024 is largely unpolished, and while reading this book, you might find yourself frustrated.
It might feel like the software is holding you back from unleashing your true potential.
In some ways, it is.
Some seemingly simple questions might lead you down complicated paths and suddenly, you have spent months worrying about subtle nuances in different compilation strategies that make you feel like your entire codebase is held together by unchewed bubble gum.

When such problems arise, it's important to breathe and reframe your question.
Sometimes it will take time.
Sometimes, there is no solution, and you will have to shrug your shoulders and work on something else for a while.
But in most cases, there will be a solution to your problem.
You just might need to get a little creative.

It is important to keep in mind that CPU languages have had years (decades) to figure out how to create fast, efficient CPU code.
GPU languages, on the other hand, are relatively new and have yet to stabilize on a lower-level scheme that works across all languages.
No matter who you ask, the GPU ecosystem (at large) is incredibly messy right now.
I really hope that this book helps clarify some of that mess.
