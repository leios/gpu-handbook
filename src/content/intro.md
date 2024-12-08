!!! note "Reviewer Notice"
    I think all the information in this chapter is good, but the order is a bit off.
    The first section, "Why should I care about graphics?" is pretty clean, but the discussion on CUDA and why I chose JuliaGPU for this book is a bit all over the place.
    
    In particular, I say:
    1. CUDA Sucks
    2. JuliaGPU (and OpenCL) are good answers
    3. But these languages have a core limitation: They are not CUDA
    
    On the one hand, I think the circular argument is a perfect way to describe the current state of GPU computing.
    On the other hand, it's a little hard to understand for new learners.
    
    Simply put, expect a rework soon.
    I am just not sure what the rework will look like, so please give me feedback!

# Why Should I Care about Graphics?

During my PhD, I got this question a lot.
To be honest, it's a good question.
If you are a scientist that regularly simulates the motion of galaxies (or some similar problem), why would you care about the latest animation from PIXAR or DreamWorks?
Well, let's talk about that.

As a reminder, GPU stands for Graphics Processing Unit.
Historically, its purpose has been to do graphics.
Games.
Visualizations.
You know.
Graphics.

These workflows typically require a lot of simple operations.
For example, we might need to move a bunch of points from one set of locations to another.
Or color a bunch pixels red (or any other color).
Or to track a bunch of rays of light bouncing around a scene.

It's not particularly difficult to whip up some code in Python, C, or Julia to solve these problems for us.
The trouble comes from the fact that these operations often need to be done a lot -- thousands or millions of times.
We also usually need the results immediately -- like within one sixtieth of a second.
When there are a large number of operations and a really short time limit, it suddenly makes sense to offload computation to a separate device that is built for that kind of work.

That's what the GPU is.
A separate device that is built to solve a lot of simple operations at the same time.

I need to stop and expand upon the three separate claims made in the previous statement.

1. **The GPU is a separate device**: This means that we often need a special protocol to use it from our programming language of choice, and we need to think about how to transfer data *to* and *from* the GPU.
2. **The GPU ... is built to solve ... *simple* operations**: This means that certain workflows are not well-suited for the GPU. We'll give more examples of these later in the book.
3. **The GPU ... is built to solve a lot of ... operations at the same time**: This means that we need to actively think about what each computational core of the GPU is doing in parallel.

I have often said that research in computational science mirrors research in computer graphics.
Computer graphics researchers generally work on hardware and software tooling for GPUs -- small, parallel devices that can fit on modern motherboards.
Computational scientists generally work on hardware and software tooling for supercomputers -- large, parallel networks of computers strung together to solve difficult problems.
In a sense, both groups have been attempting to do the same thing: break up complex tasks into simpler ones so they make better use of parallel hardware.
Eventually, the two forces met and General Purpose GPU (GPGPU) computing was born.
Nowadays, the fastest supercomputers in the world use GPUs for computation.
It's pretty clear that the GPU does more than "just graphics."

## But What If I Actually Care About Graphics?

Another great question!

This book is specifically written for students who want to use their GPU for more general applications (like large-scale simulations).
It is a little unfortunate that the programming interfaces used for graphics are typically quite different than those used for computing.
If you are interested in building a game or rendering engine, it might be best to think of this book as a way to satiate some idle curiosity that might be lingering in the back of your head.
It's all good to know, but it's ok to read it for fun instead of rigor.

That said, there are still a number of good reasons to keep reading:
1. It is entirely possible to use the lessons learned from this book to do "software rendering," which can be more flexible than traditional graphics workflows.
2. We'll be discussing several graphical applications that are well-suited for compute workflows, such as ray marching and splatting.
3. Even within traditional graphics workflows, there are several applications that use "compute shaders" for various reasons (volume rendering and particle systems both come to mind). Compute shaders are almost identical to the functions we will be writing in this book.
4. This book should give you some key intuition about how and why the GPU works the way it does, which could be quite valuable for performance engineering down the road.
5. We will discuss the abstractions used in graphical GPU interfaces in the next chapter.

But there is a larger question here.
Why is there such a big difference between interfaces for graphics and interfaces for computation?
After all, we are all programming for the same device, right?
At the end of the day, it's all GPU.

Well, this brings something I really have to say. 
An unfortunate truth about GPU computing in 2024 that all students must be aware of before proceeding further.
No matter what language, interface, or method you decide to use to program for your GPU, they all share one thing in common: jank.

Simply put, GPU interfaces are way, way less polished than you might expect when transitioning from "traditional" CPU programming.
Some of this is because GPUs are inherently parallel devices, while CPU code is often written without parallelism in mind.
But I would argue that majority of programmers struggling with GPU programming in 2024 are not necessarily struggling with concepts, but are instead limited by the software used to implement those concepts.

I think now is a good time to talk about the GPU ecosystem as a whole, and in particular...

## The Big Green Elephant in the Room

Every now and again, I'll get stuck on a problem.
It happens to the best of us, and I am certainly not one of the best.
There are many different strategies to getting out of such a rut.
Some people might take a walk and think about something else for a while.
Others might drill down and try to find another solution from a different angle.
Still others, might rip off all their clothes, jump in the bath, and have a deep, insightful conversation about their problem with a small yellow duck floating next to their head.

I guess I usually take that last approach.
Except I am fully clothed.
And not *usually* submerged in a body of water.
And my "yellow duck" is actually a bunch of random people who listen to me ramble about useless things while livestreaming on Twitch or YouTube.

While streaming, I would often get asked questions.
Some were useful.
Some were not.
But some questions were repeated time and time again.
One such question was, "As a beginner, how do I start programming?"

It's a really good question without a clear answer.
I would often say, "the only way to start programming is just to start programming,"
and then follow up that statement with specific projects the person could work on to get them started.
I find that working through a few meaningful examples is always a good way to start learning anything and have structured this book around that theme.

But there's something deeply wrong with my statement.
If someone is truly starting with absolutely no knowledge about programming, how do they even know where to start?
What programming language do they use?
What development environment?
What concepts should they target first?

These are all good questions, and (in fact), might be the very same questions you are asking yourself right now when it comes to GPU programming.
As hard as these problems are to answer, for most people, there are a few good starting points.
You can't go wrong with Python or Julia as a starter language.
If you want more rigor, go C or C++.
If you want an active community, go Rust.
Game devs might consider C#.
Web devs, honestly, should talk to someone else.
There are many such recommendations I could make based on the student's specific goals.

But when it comes to GPU computing, there are no clear-cut guidelines.
In fact, in 2024, there is no single language that I can truly recommend.
For those who know GPU computing, you might be raising your eyebrow at the previous sentence.
After all, there certainly is a single programming interface that has dominated the GPGPU space for literal decades.
It has so much market share, that the company in charge of its design is now one of the most profitable companies in the history of our planet.
Yes, I am talking about NVIDIA and their programming interface CUDA.

Yet, the fastest supercomputers in the world today (in 2024), do not use cards from NVIDIA and are largely unable to run CUDA code.
If you are a research scientist targeting these devices, it might be a good idea to choose another language.

And what about "real" graphics?
What if you want to make a game or animation?
Well, you will probably be using OpenGL, DirectX, or Vulkan.
More accurately, you will probably be using some sort of game or graphics engine built on top of any of the aforementioned tools.
Regardless, it's pretty clear you will not be using CUDA.

If you want your code to run on a smartphone GPU, CUDA is not suitable.
If you want the code to run performantly on a parallel CPU configuration without having to rewrite everything, yet again, CUDA is not suitable.
If you have an AMD, Intel, or Apple Silicon GPU, yet again (again), CUDA is not suitable.

Now, please keep in mind, I am not discouraging the use of CUDA.
It is a fantastic language that has been the unofficial king / queen of GPU computing for a long time and there are a lot of good reasons for that.
In fact, I am actively encouraging you to rewrite all the code in this book in CUDA if you want.

I am mainly just echoing a point I made before.
The current state of GPU computing is messy.
Even though most programmers go with CUDA by default, it doesn't mean that CUDA is the best tool for every job.

More than that, I have no idea who is reading this book or what devices they have available.
I can't count on everyone having an NVIDIA GPU to use, but I am certain they have some device at their disposal that can run GPU code, so I will focus on languages (or rather a single language) that I am confident the majority of my audience can use.

### If not CUDA, then What?

After a lot of thought, I settled on using Julia and the KernelAbstractions(.jl) package for this book.
There are benefits and drawbacks of this choice, which I could ramble about for hours, but in short, Julia provides:

1. A flexible software ecosystem that works on any GPU vendor (AMD, NVIDIA, Apple Silicon, Intel).
2. The ability to write code that can execute both on the GPU and in parallel on the CPU at the same time.
3. A way to execute GPU code without writing GPU-specific functions or "kernels."
4. A straightforward package management approach so users don't have to think about library installation.

There are a few other benefits, but this specific combination of useful features cannot be found anywhere else.

To be clear, the Open Compute Language (OpenCL) also shares many of these advantages and even has a few distinct benefits over Julia as well.
Unfortunately, OpenCL is a little less straightforward to use.
The way I see it, this book is about teaching GPU concepts, and the JuliaGPU ecosystem lets me quickly start doing just that.
If I were to write this book for OpenCL (or even CUDA), I would need to spend a significant amount of time explaining syntax and odd quirks to C (or god-forbid C++), that I just don't want to deal with.
Again, I am actively encouraging you to rewrite this entire book in the language of your choice.
For me, I'm planning to stick to Julia, but there is a core limitation to this choice I will mention at the end of this chapter.

Also, to be completely transparent, I have contributed to the GPU ecosystem in Julia in several ways, including the KernelAbstractions package we will be using for this work.
This could be seen as a net benefit.
After all, how often do you get to read a book from a developer of the API you will be using?
On the other hand, I need to acknowledge my biases and let you (the reader) know that several of my opinions might be a little too favorable towards Julia and that your day-to-day experience with the language might fall a little short depending on your familiarity.

On the other (other) hand, I really do try to be as objective as possible when talking about projects I am passionate about.
There's nothing worse than being sold a tool you can't actually use in practice.
That's why I am absolutely encouraging you to take the code in this book and rewrite it into the language of your choice.

But there is still another catch.
One that is much harder to explain.
One I hinted at earlier in this section.
Next, let's talk about...

### The Fragmentation of Modern GPU Interfaces

When you buy a CPU, it doesn't matter whether you buy one from AMD or Intel, both will work approximately the same regardless of whether you are using Python, C, Rust, or any other language.
Unfortunately, that is not the case when it comes to GPUs.
Everything is a complete mess that is really hard to navigate for new programmers.
In this section, I am going to do my best to explain the that mess without also overwhelming you with too much information.
Please bear with me.

So, CUDA only really works on NVIDIA devices.
ROCm is probably the closest to CUDA you can get with AMD cards.
If you are running a modern Mac (with Apple Silicon), then you will be encouraged to use Metal, which is a hybrid graphics and compute interface.

None of these languages talk to each other.
You can't run Metal on NVIDIA cards.
You can't run ROCm on Macs.

But what if you are writing "real" software and have multiple users, all with different hardware?
One might use a Mac.
Another might use an Intel GPU.
Another, an NVIDIA one.
What do you do?

Good question.
Really good question.
Let me know when you have an answer because I am interested too.

The way I see it, there are 2 solutions:
1. Support all the different backends for each individual use-case.
2. Write your code in a cross-platform interface.

I think option 1 is self-explanatory.
You'll have to maintain some CUDA code for NVIDIA users.
Some Metal code for Mac users.
Some ROCm code for AMD Users.
And so on.

Basically, any time you need to change one of your GPU functions, you need copy that change along to all the other vendors to keep all your users happy.
It's a pain, but doable.
It just requires a bit of testing and a few afternoons of debugging for each backend.

But there must be a better way, right?

Kinda.
Cross-platform GPU interfaces allow you to write functions that run at essentially the same speed as vendor-specific APIs (like CUDA), but those functions are not limited to specific hardware, so the same code can run on AMD, Intel, Apple Silicon, and NVIDIA hardware.
In fact, many cross-platform interfaces allow for that same code to run in parallel on the CPU as well.
OpenCL can even run on many cell phones and Field Programmable Gate Arrays (FPGAs), which are separate devices used in completely different types of problems for performance reasons.

So what's the catch? 
Well, it's hard to overstate how incredibly dominant CUDA has been in the GPGPU space for so many years.
Sure, you *could* write your code in a cross-platform way, but why would you?
You would be taking a small performance hit (something like 10%) and it would take an extra week to write your code.
Plus, all of the common GPU programming guides are in CUDA.
Time is money, and it takes time to learn.
From a business perspective, it's better to just pay an extra hundred dollars on an NVIDIA card and save yourself (and your employees) the hassle.

To reiterate, almost all non-CUDA interfaces have the same drawback: they are not CUDA.
This means that there is less documentation available.
The code will be buggier and with less developer support.
The experience simply won't be as smooth as CUDA.
In a world where everyone is trying to get the absolute best performance possible as quickly as possible, these are huge issues.

Long story short, it's impossible to talk about GPU computing without acknowledging the big green elephant in the room: CUDA.

I think now is as good of a time as any to slap a big disclaimer on top of this work.
Next up...

!!! note "Reviewer Notice"
    This section needs a rework. I think it's all valuable information, but maybe it's best to talk about when we do raymarching or splatting? Something to compare and contrast with "software rendering" approaches.

## The Jank

Yeah.
I'm going to come out and say it.
No matter what language or interface you use for GPU programming in 2024, you will probably find yourself at least a little disappointed.
They all feel a little rough, lacking the polish that programmers are used to nowadays.
To explain what the problem is in full, we need to take a step back.
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

## General Structure and Limitations of this Book

As much as I hate to say it, our time on this Earth is limited.
It goes without saying that there are things I *can* cover, and things I *can't*.

My ultimate goal with this book is to provide a "quick-start" guide for those wanting to learn how to get started with GPU computing.
That means that I intend to cover a number of core ideas and concepts that are necessary to consider when trying to achieve good performance on the GPU as well as key applications that I find interesting and useful for a diverse background of research fields.

!!! note "Reviewer Notice"
    I'll be coming back to this section later with a full overview once the chapters are more-or-less finalized

For now, I also want to quickly discuss several core limitations of this book:
1. We will not be surveying different languages. This book is primarily intended to teach concepts over code. Once you master everything here, it should be relatively straightforward to translate it to whatever language you need for your final application. With that said, I will be highlighting languages and their differences as they become relevant in their respective sections.
2. We will not be discussing specialized hardware that certain vendors add to their GPUs. This means no discussion of (for example) hardware rasterization, raytracing (except in software), or tensor cores.
3. We will not be analyzing performance via NVIDIA-specific tooling like NSight compute. I simply don't think it is fair to have a chapter on performance analysis that only works for NVIDIA devices.

I think that's enough rambling for now.
Let's get to coding.
In the next chapter, I'll be introducing several core abstractions programmers use when writing GPU code and getting you started in running that code on your hardware (whatever that might be).
