# The Contents of this Book

When I started my PhD in 2014, it was fairly uncommon for programmers to use their Graphics Processing Unit (GPU) for any computation beyond what was necessary for gaming or some graphical applications.
The world has changed since then.
Computer Generated Imagery (CGI) for movies and games have become almost photorealistic, and all of the necessary computation happens on the GPU.
The fastest supercomputers in the world run GPUs.
Machine learning models are trained using GPUs

It really feels like the GPU is the most important piece of hardware on any computational device (supercomputers, desktops, phones, etc).
Everyone needs the GPU for *something*.
At the same time, the software ecosystem to write GPU programs is somehow incredibly messy and divided.
It is certainly not the smooth experience programmers are used to when coding for the Central Processing Unit (CPU).

The fact is that the GPU is not the CPU.
In many ways, it is impossible to write code that can run performantly on both devices.
The biggest difference is in how programmers reason about parallelism -- the usage of multiple computational cores at the same time.
In many CPU programs, parallelism is an afterthought.
Something you *might* do if you need extra performance down the line.
For the GPU, it is one of the most important aspects of writing code.
Period.

There are several other differences.
For example, CPU programmers typically think about the amount of time it takes to perform specific operations.
GPU programmers, on the other hand, focus on how much time it takes to *move data around*, because that is usually the bottleneck to great GPU performance.
As a side note, this is why I always argue that complexity analysis (a back-of-the-envelope calculation of how many operations are needed to do a computation) tends to break down on the GPU.
It's not that complexity analysis is a bad metric by any means.
It's definitely useful.
But sometimes, you want to use a more complex algorithm in order to better use your hardware.
I'll show off a relatively famous example of this later in the book.

Long story short, we live in a world where most programmers have no idea how to use the most important piece of hardware they have access to on their machines.
And that's a shame.
There are simply very few good resources out there to teach GPU programming from the ground up, which means most programmers need to teach themselves the technology.

On the other hand, there is an interesting quirk to learning GPU computing that everyone knows, but no one talks about.
Even though every person has "taught themselves" how to write code for GPUs, they almost always stumble upon the same curriculum -- a set of example problems that teach all the concepts they might need to really get the performance out of their hardware.

So that's what this book is.
A series of example problems to teach everyone how to write code for GPUs.

I will note that I *do* have an ulterior motive.
Simply put, I want more people to engage with some of the research I have been doing and it's quite difficult for people to do so when there is a prohibitively complex piece of technology standing in the way.
So I'm here trying to break the technology down and (hopefully) make it a little less scary.

Peace,
Dr. James Schloss (Leios)
