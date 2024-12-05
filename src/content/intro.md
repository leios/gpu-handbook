# Why Should I Care about Graphics?

During my PhD, I got this question a lot.
And it's a good question.
If you are a scientist who is used to simulating the motion of galaxies, why would you care about the latest animation from PIXAR or DreamWorks?
Well, let's talk about that.

As a reminder, GPU stands for Graphics Processing Unit.
Historically, it's core purpose has been to do graphics.
Games.
Visualizations.
You know.
Graphics.

It just so happens that these workflows typically require a lot of simple operations.
For example, we might need to move a bunch of points from one set of locations to another.
Or color a bunch pixels red (or any other color).
Or to track a bunch of rays of light bouncing around a scene.

It's not particularly difficult to whip up some code in Python, C, or Julia to solve these problems for us.
The trouble comes from the fact that these operations often need to be done a lot -- thousands or millions of times.
We also usually need the results immediately -- like within one sixtieth of a second.
When you have such a large number of operations and a really short time limit, it suddenly makes sense to offload the computation to a separate device that is built for that kind of work.

And that's what the GPU is.
A separate device that is built to solve a lot of simple operations at the same time.

I need to stop and expand upon the three separate claims made in the previous statement.

1. **The GPU is a separate device**: This means that we often need a special protocol to access it from our programming language of choice, and we need to think about how to transfer data *to* and *from* the GPU.
2. **The GPU ... is built to solve ... *simple* operations**: This means that certain workflows are not well-suited for the GPU. We'll give more examples of these later in the book.
3. **The GPU ... is built to solve a lot of ... operations at the same time**: This means that we need to actively think about what each computational core of the GPU is doing in parallel.

I have often said that research in computational science mirrors research in computer graphics.
Computer graphics researchers generally work on hardware and software tooling for GPUs -- small, parallel devices that can fit on modern motherboards.
Computational scientists generally work on hardware and software tooling for supercomputers -- large, parallel networks of computers strung together to solve difficult problems.
In a sense, both groups have been attempting to do the same thing: break up complex tasks into simpler ones so they make better use of parallel hardware.
Eventually, the two forces met and General Purpose GPU (GPGPU) computing was born.
Nowadays, the fastest supercomputers in the world use GPUs for computation.
It's pretty clear that the GPU does more than "just graphics."

Throughout this book, I will be actively resisting the urge to compare the experience of programming for the GPU with it's more popular cousin the Central Processing Unit (CPU), which is the default computational device for most programming workflows.
The way I see it, the CPU and GPU are so different that it is often misleading to constantly relate GPU programming to similar methods on the CPU.
I will say this: even after learning GPU programming, there may still be many applications that are easier to implement and faster on the CPU
The opposite is also true.
There are many workflows that are easier to implement and (much) faster on the GPU.

## But What If I Actually Care About Graphics?

Another great question!

This book is specifically written for students who want to use their GPU for more general applications (like large-scale simulations).
If you are reading this book with the hopes of building a game or rendering engine, it might be better for you to look elsewhere (maybe into guides for Vulkan or OpenGL).

That said...
1. It is entirely possible to use the lessons learned from this book to do "software rendering," which can be more flexible than traditional graphics workflows.
2. Even within traditional graphics workflows, there are several applications that use "compute shaders" for various reasons (volume rendering and particle systems both come to mind). Compute shaders are almost identical to the functions we will be writing in this book.
3. This book should give you some key intuition about how and why the GPU works the way it does, which could be quite valuable for performance engineering down the road.

So if you are interested in "real" graphics, think of this book as a way to satiate some idle curiosity that might be lingering in the back of your head.
It's all good to know, but it's ok to read it for fun instead of rigor.

Speaking of which, I have thrown a few languages at you already.
In the previous section, I mentioned Python, Julia, and C.
Here, I mentioned Vulkan and OpenGL.
It's time.

Let's talk about...

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
If you want a bigger community, go Rust.
Game devs might consider C#.
Web devs, honestly, should talk to someone else.
There are many such recommendations I could make based on the student's specific goals.

But when it comes to GPU computing, there are no clear-cut guidelines.
In fact, in 2024, there is no single language that I can truly recommend.
For those who know GPU computing, you might be raising your eyebrow at the previous sentence.
After all, there certainly is a single language that has dominated the GPGPU space for literal decades.
It has so much market share, that the company in charge of its design is now one of the most profitable companies in the history of our planet.
Yes, I am talking about NVIDIA and their programming language CUDA.

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

My point is that the current state of GPU computing is messy.
Even though most programmers go with CUDA by default, it doesn't mean that CUDA is the best tool for every job.

More than that, I have no idea who is reading this book or what devices they have available.
I can't count on everyone having an NVIDIA GPU to use, but I am certain they have some device at their disposal that can run GPU code, so I will focus on languages (or rather a single language) that I am confident the majority of my audience can use.

That is why (after a lot of thought) I settled on using Julia and the KernelAbstractions(.jl) package for this book.
There are benefits and drawbacks of this choice, which I could ramble about for hours, but in short, Julia provides:

1. A flexible software ecosystem that works on any GPU vendor (AMD, NVIDIA, Apple Silicon, Intel).
2. The ability to write code that can execute both on the GPU and in parallel on the CPU at the same time.
3. A way to execute GPU code without writing GPU-specific functions or "kernels."
4. A straightforward package management approach so users don't have to think about library installation.

There are a few other benefits, but this specific combination of useful features cannot be found anywhere else.

Now for the "catch."
The be completely transparent, I have contributed to the GPU ecosystem in Julia in several ways, including the KernelAbstractions package we will be using for this work.
This could be seen as a net benefit.
After all, how often do you get to read a book from a developer of the API you will be using?
On the other hand, I need to acknowledge my biases and let you (the reader) know that several of my opinions might be a little too favorable towards Julia and that your day-to-day experience with the language might fall a little short depending on your familiarity.

On the other (other) hand, I really do try to be as objective as possible when talking about projects I am passionate about.
There's nothing worse than being sold a tool you can't actually use in practice.
That's why I am absolutely encouraging you to take the code in this book and rewrite it into the language of your choice.

But there is still another catch.
One that is much harder to explain.
One I hinted at earlier in this section.

When you buy a CPU, it doesn't matter whether you buy one from AMD or Intel, both will work approximately the same regardless of whether you are using Python, C, Rust, or any other language.
Unfortunately, that is not the case when it comes to GPUs.
As stated previously, CUDA only really works on NVIDIA devices.
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

Basically, any time you need to change one of your GPU functions, you need copy that change along to all the other vendors to make sure all of your users get the change.
It's a pain, but doable.
It just requires a bit of testing and a few afternoons of debugging for each backend.

Ok, but there must be a better way, right?

Right?

### The state of cross-platform APIs

Well, I've got good news for you (kinda).
There are actually a number of APIs that can be used on essentially any hardware.
The traditional example is the Open Compute Language (OpenCL).

It's great.
Your functions run at essentially the same speed as vendor-specific APIs (like CUDA).
It'll run anywhere (AMD, NVIDIA, Apple Silicon, Intel).
Heck, it will even run on parallel CPU configurations and a bunch of smartphones.
It also supports Field-Programmable Gate Arrays (FPGAs), which are completely different than GPUs and used in specific (different) use-cases for performance.

So what's the catch? Well...
1. OpenCL doesn't have as great library support.  So if you want to do a Fast Fourier Transform on some data using OpenCL, it will be marginally slower and a little more difficult to use than the corresponding features in CUDA.
2. OpenCL is also a little clunkier to use than CUDA for many workflows.  On the other hand, there are some workflows where OpenCL is genuinely the easiest option.

You might think to yourself, "These sound like totally fair concessions to make when considering that OpenCL code can run on any hardware."
And you would not necessarily be wrong.

But it's hard to overstate how incredibly dominant CUDA has been in the GPGPU space for so many years.
Sure, you *could* write your code in a cross-platform way, but why would you?
You would be taking a small performance hit (something like 10%) and it would take an extra week to write your code.
Plus, all of the common GPU programming guides are in CUDA.
Time is money, and it takes time to learn.
From a business perspective, it's better to just pay an extra hundred dollars on an NVIDIA card and save yourself (and your employees) the hassle.

To reiterate, almost all of the cross-platform APIs have the same drawback: they are not CUDA.
This means that there is less documentation available.
The code will be buggier and with less developer support.
The experience simply won't be as smooth as CUDA.
In a world where everyone is trying to get the absolute best performance possible as quickly as possible, these are huge issues.

Well, you caught me rambling again.
Long story short, it's impossible to talk about GPU computing without acknowledging the big green elephant in the room: CUDA.

The good news is that JuliaGPU (my choice for this book) is actually using CUDA under the hood if you are using NVIDIA hardware.
It's using Metal for Mac, OneAPI for Intel, ROCm for AMD, and a portable version of OpenCL (POCL) for CPU parallelism.
This alleviates some of the pain points when using other cross-platform languages.
I'm hoping that this book spurs more developers to try JuliaGPU out and helps us catch bugs and build documentation where needed so we can catch up to CUDA.

We'll see what the future holds, but I am positive there is a bright future for the JuliaGPU ecosystem.
At the very least, it's a great language to play with to learn all of the essential concepts before (potentially) rewriting things for some broader application.

In the next chapter, I'll be introducing several core abstractions programmers use when writing GPU code and getting you started in running that code on your hardware (whatever that might be).
