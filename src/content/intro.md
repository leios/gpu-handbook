# Why Should I Care about Graphics?

During my PhD, I got this question a lot.
To be honest, it's a good question.
If you are a scientist that studies the motion of galaxies (or some similar problem), why would you care about the latest animation from PIXAR or DreamWorks?
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
2. We'll be discussing several graphical applications that are well-suited for computational workflows, such as ray marching and splatting.
3. Even within traditional graphics workflows, there are certain applications that use "compute shaders" for various reasons (volume rendering and particle systems both come to mind). Compute shaders are almost identical to the functions we will be writing in this book.
4. This book should give you some key intuition about how and why the GPU works the way it does, which could be quite valuable for performance engineering down the road.

But there is a larger question here.
Why is there such a big difference between interfaces for graphics and interfaces for computation?
After all, we are all programming for the same device, right?
At the end of the day, it's all GPU.

Well, this brings up something that I really have to say before continuing further. 
An unfortunate truth about GPU computing in 2025 that all students must be aware of before proceeding further.
No matter what language, interface, or method you decide to use for GPU programming, they all share one thing in common: jank.

Simply put, GPU interfaces are way, way less polished than you might expect when transitioning from "traditional" CPU programming.
Some of this is because GPUs are inherently parallel devices, while CPU code is often written without parallelism in mind.
But I would argue that majority of programmers struggling with GPU programming in 2025 are not necessarily struggling with concepts, but are instead limited by the software used to implement those concepts.

I think now is a good time to talk about the GPU ecosystem as a whole, and in particular...

!!!info "Reviewer Notice"
    Work these two sections together

## The Big Green Elephant in the Room

It is often very difficult to recommend a GPU language or programming interface.
In fact, in 202X, there is no single language that I can truly recommend.
For those who know GPU computing, you might be raising your eyebrow at the previous sentence.
After all, there certainly is a single programming interface that has dominated the GPGPU space for literal decades.
It has so much market share, that the company in charge of its design is now one of the most profitable companies in the history of our planet.
Yes, I am talking about NVIDIA and their programming interface CUDA.

The problem is that CUDA only works on NVIDIA cards, so if you write CUDA code, you must necessarily also have NVIDIA hardware available.
That's not always the case.
A bunch of people choose AMD hardware instead of NVIDIA.
Many people are running macs.
Some are just using their phone as a computer.

The fact is that we have no control over the hardware our users might have.
More than that, every hardware vendor provides their own, distinct programming interface that will almost certainly fail to cooperate with other interfaces from different vendors.
Simply put, CUDA works for NVIDIA hardware.
ROCm is for AMD.
Metal is for Apple Silicon (Macs).
None of these languages talk to each other.
So what do we do?
Well, the "obvious" solution would be to support all possible hardware, but this means that any time we need to make a minor change to our code, we also need to mirror that change to all of the other programming interfaces for all of the different hardware vendors.
What might have been a single afternoon of work might suddenly turn into a week of testing and still failing to get everything right.

But there must be a better way, right?

Kinda.
Cross-platform GPU interfaces allow you to write functions that run at essentially the same speed as vendor-specific APIs (like CUDA), but those functions are not limited to specific hardware.
This means that the same code can run on AMD, Intel, Apple Silicon, and NVIDIA hardware.
In fact, many cross-platform interfaces allow for that same code to run in parallel on the CPU as well.
In particular, the Open Compute Language (OpenCL) can even run on many cell phones and Field Programmable Gate Arrays (FPGAs), which are separate devices used in completely different types of problems for performance reasons.

So what's the catch? 
Why doesn't everyone use cross-platform interfaces.
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

Still, I have no idea who is reading this book or what devices they have available.
I can't count on everyone having an NVIDIA GPU to use, and for that reason alone I do not feel that CUDA is suitable for this work.
That said, I am certain everyone will have some device at their disposal that can run GPU code, so I will focus on languages (or rather a single language) that I am confident the majority of my audience can use.

### If not CUDA, then What?

After a lot of thought, I settled on using Julia and the KernelAbstractions(.jl) package for this book.
There are benefits and drawbacks of this choice, which I could ramble about for hours, but in short, Julia provides:

1. A flexible software ecosystem that works on any GPU vendor (AMD, NVIDIA, Apple Silicon, Intel).
2. The ability to write code that can execute both on the GPU and in parallel on the CPU at the same time.
3. A way to execute GPU code without writing GPU-specific functions or "kernels."
4. A straightforward package management approach so users don't have to think about library installation.

There are a few other benefits, but this specific combination of useful features cannot be found anywhere else.

!!!info "Reviewer Notice"
    What core limitation

To be clear, the Open Compute Language (OpenCL) also shares many of these advantages and even has a few distinct benefits over Julia as well.
Unfortunately, OpenCL is a little less straightforward to use.
The way I see it, this book is about teaching GPU concepts, and the JuliaGPU ecosystem allows me to quickly do just that.
If I were to write this book with OpenCL (or even CUDA), I would need to spend a significant amount of time explaining syntax and odd quirks to C (or god-forbid C++), that I just don't want to deal with.
Again, I am actively encouraging you to rewrite this entire book in the language of your choice.
For me, I'm planning to stick to Julia, but there is a core limitation to this choice I will mention at the end of this chapter.

Also, to be completely transparent, I have contributed to the GPU ecosystem in Julia in several ways, including the KernelAbstractions package we will be using for this work.
This could be seen as a net benefit.
After all, how often do you get to read a book from a developer of the API you will be using?
On the other hand, I need to acknowledge my biases and let you (the reader) know that several of my opinions might be a little too favorable towards Julia and that your day-to-day experience with the language might fall a little short depending on your familiarity.

On the other (other) hand, I really do try to be as objective as possible when talking about projects I am passionate about.
There's nothing worse than being sold a tool you can't actually use in practice.
That's why I am absolutely encouraging you to take the code in this book and rewrite it into the language of your choice.

Alright.
That's enough rambling.
We'll be doing a lot more of it later.
Now, let's talk about the...

## General Structure and Limitations of this Book

As much as I hate to say it, our time on this Earth is limited.
It goes without saying that there are things I *can* cover, and things I *can't*.

My ultimate goal with this book is to provide a "quick-start" guide for those wanting to learn how to get started with GPU computing.
That means that I intend to cover a number of core ideas and concepts that are necessary to consider when trying to achieve good performance on the GPU as well as key applications that I find interesting and useful for a diverse background of research fields.
To do this, I have (more or less) structured this book around interesting, key examples intended to demonstrate the lessons I would like to teach.
There will certainly be areas I miss, but I hope the areas I get to will be generally useful for the most possible people.

!!! note "Reviewer Notice"
    I'll be coming back to this section later with a full overview once the chapters are more-or-less finalized

It is also important to discuss several known limitations of this book:
1. We will not be surveying different languages. This book is primarily intended to teach concepts over code. Once you master everything here, it should be relatively straightforward to translate it to whatever language you need for your final application. With that said, I will be highlighting languages and their differences as they become relevant in their respective sections.
2. We will not be discussing specialized hardware that certain vendors add to their GPUs. This means no discussion of (for example) hardware rasterization, raytracing (except in software), or tensor cores.
3. We will not be analyzing performance via NVIDIA-specific tooling like NSight compute. I simply don't think it is fair to have a chapter on performance analysis that only works for NVIDIA devices.

With all that said, I think it's time to finally start coding!
In the next chapter, I'll be introducing several core abstractions programmers use when writing GPU code and getting you started in running that code on your hardware (whatever that might be).
