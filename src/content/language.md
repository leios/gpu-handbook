# So graphics?

Move "big green elephant in the room" to the end.
Start with Graphics vs Compute

Look.
I'll be honest, feel free to skip this chapter.
Or don't.

On the one hand, it is filled with a bunch of context about the state of GPU computing in 2024, which will definitely help you in understanding some of the finer 
ch

# Language Doesn't Matter

... Is something I wish I could say.
Unfortunately, it ignores the reality of the world we live in.

Right now, there is no single language that I can truly recommend for GPU computing.
For those who know GPU computing, you might be raising your eyebrow at the previous sentence.
After all, there certainly is a single language that has dominated the GPGPU space for literal decades.
It has so much market share, that the company in charge of its design is now one of the most profitable companies in the history of our planet.
Yes, I am talking about NVIDIA and their programming language CUDA.

Yet, the fastest supercomputers in the world today (in 2024), do not use cards from NVIDIA and are largely unable to run CUDA code.
If you are a research scientist targetting these devices, it might be a good idea to choose another language.

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
I can't count on them having an NVIDIA GPU to use, but I am certain they have some device at their disposal that can run GPU code, so I will focus on languages (or rather a single language) that I am confident the majority of my audience can use.

After a lot of thought, I settled on using Julia and the KernelAbstractions(.jl) package for this book.
There are benefits and drawbacks of this choice, which I will outline throughout the rest of this chapter, but in short, Julia provides:

1. A flexible software ecosystem that works on any GPU vendor (AMD, NVidia, Apple Silicon, Intel).
2. The ability to write code that can execute both on the GPU and in parallel on the CPU at the same time.
3. A way to execute GPU code without writing GPU-specific functions or kernels.
4. A straightforward package management approach so users don't have to think about library installation.

There are a few other benefits, but this specific combination of useful features cannot be found anywhere else.

Now for the "catch."
The be completely transparent, I have contributed to the GPU ecosystem in Julia in several ways, including the KernelAbstractions package we will be using for this work.
This could be seen as a net benefit.
After all, how often do you get to read a book from a developer of the API you will be using?
On the other hand, I need to acknowledge my biases and let you (the reader) know that several of my opinions might be a little too favorable and that your day-to-day experience with the language might fall a little short depending on your familiarity.

On the other (other) hand, I really do try to be as objective as possible when talking about projects I am passionate about.
There's nothing worse than being sold a tool you can't actually use in practice.
That's why I am absolutely encouraging you to take the code in this book and rewrite it into the language of your choice.

For the rest of this chapter, I will try to discuss a host of "things that are good to know" about the current state of GPGPU programming.
I fully expect you to skip around and read sections of interest or possibly skip skip ahead to the next chapters on the GPU software-harware interface or specific examples.
This is a book.
It's up to you to read it how you feel best suits you.

## The big green elephant in the room

When you buy a CPU, it doesn't matter whether you buy one from AMD or Intel, both will work approximately the same regardless of whether you are using Python, C, Rust, or any other language.
Unfortunately, that is not the case when it comes to GPUs.
As stated in the previous section, CUDA only really works on NVidia devices.
ROCm is probably the closest to CUDA you can get with AMD cards.
If you are running a modern Mac (with Apple Silicon), then you will be encouraged to use Metal, which is a hybrid graphics and compute API.

None of these APIs talk to each other.
You can't run Metal on NVidia cards.
You can't run ROCm on Macs.

But what if you have multiple users?
One uses a Mac.
Another uses an Intel GPU.
Another uses an NVidia one.
What do you do?

Good question.
Really good question.
Let me know when you have an answer because I am interested too.

The way I see it, there are 2 solutions:
1. Support all the different backends for individual use-cases.
2. Write your code in a cross-platform API

I think option 1 is self-explanatory.
You'll have to maintain some CUDA code for NVidia users.
Some Metal code for Mac users.
Some ROCm code for AMD Users.
And so on.

Basically, any time you need to change one of your GPU functions, you need copy that chain along to all the other vendors to make sure all of your users get the change.
It's a pain, but doable.
It just requires a bit of testing and a few afternoons of debugging for each backend.

Ok, but there must be a better way, right?

Right?

### The state of cross-platform APIs

Well, I've got good news for you (kinda).
There are actually a number of APIs that can be used on essentially any hardware.
The traditional example is the Open Compute Language (OpenCL).

It's great.
Your functions run at essentially the same speed as vendor-specific APIs.
It'll run anywhere (AMD, NVidia, Apple Silicon, Intel).
Heck, it will even run on parallel CPU configurations and a bunch of smartphones.
It can even support Field-Programmable Gate Arrays (FPGAs), which are completely different than GPUs and used in specific (different) use-cases for performance.

So what's the catch?
Well, OpenCL doesn't have as great library support.
So if you want to do a Fast Fourier Transform on some data using OpenCL, it will be marginally slower and a little more difficult to use than the corresponding features in CUDA.
OpenCL is also a little clunkier to use for many workflows.

You might think to yourself, "Ah, that doesn't sound too bad," or "That seems like a totally fair price to pay considering that OpenCL code can run on any hardware."
And you would not necessarily be wrong.

But it's hard to overstate how incredibly dominant CUDA has been in the GPGPU space for so many years.
Sure, you *could* write your code in a cross-platform way, but why would you?
You would be taking a small performance hit (something like 10%) and it would take longer to write your code.
Plus, all of the common GPU programming guides are in CUDA.
Time is money, and it takes time to learn.
From a business perspective, it's better to just pay an extra hundred dollars on an NVidia card and save yourself (and your emplyees) the hassle.

To reiterate, almost all of the cross-platform APIs have the same drawback: they are not CUDA.
This means that there is less documentation available.
The code will be buggier and with less developer suport.
The experience simply won't be as smooth as CUDA.
In a world where everyone is trying to get the absolute best performance possible as quickly as possible, these are huge issues.

Well, you caught me rambling again.
Let's talk about more useful divisions within the GPU community.
Namely, the difference between compute and graphics APIs

## Graphics vs Compute

As a reminder, GPU stands for Graphics Processing Unit.
It's core purpose is to do graphics.
Games.
Visualizations.
You know.
Graphics.

It just so happens that graphics work requires a lot of simple operations.
We need to move a bunch of vertces from one set of locations to another.
We need to color a bunch pixel red (or any other color).
We need to track a bunch of rays of light bouncing around a scene.

It's stuff that the CPU can make short work of, but because there are simply so many operations to do, it is best to offload the work to another device that can handle more tasks all at once.
So that's what the GPU does.
It does simple tasks in parallel.

Then the hardware got better, and the simple tasks weren't so simple anymore.
And then researchers got smarter and learned how to rephrase their problems as operations the GPU could "easily" solve.
When you put two and two together, you get GPU computing.

But there are still people who use the GPU for graphics and it's important to talk about what is available in that space as well.
In fact, many APIs are good at doing both graphics and compute, so why not use those for both?

It just so happens that as the hardware got better and reseachers became more clever, there

## Loop Vectorization

## Kernel Approaches

## JuliaGPU

## A note

I strongly encourage you to choose whatever language you want and implement the examples in this book with that language.
It's a great learning exercise if nothing else.
