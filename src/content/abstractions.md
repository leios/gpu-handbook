## Abstractions good or bad?

An abstraction exists to allow programmers to more easily construct code in a way that makes sense and can be easily understood by hardware.
An abstraction is a programming concept to make the hardware more accesible to the programmer.

## Available abstractions with JuliaGPU

## broadcasting

## Kernel Approaches

Mention that we can use CUDA.jl or AMDGPU.jl

## Loop Vectorization

Let's talk about something that is seemingly trivial: loops.

I think most people who have done programming before have seen a loop:

```
for i = 1:10
    println(i)
end
```

This statement says `for` each element (labelled as `i`) in the range between one and ten (signified by `i = 1:10`), we will print that element (`println(i)`).
The syntax varies from language to language, but there are very few mainstream languages that do not support a similar syntax.
In fact, because loops are so prevalent in CPU programming, it's quite common for coders to reuse the syntax for parallel processing.
For example, if I wanted to run the previous loop in parallel on the CPU in Julia, I would do 2 things:

1. Launch Julia with a certain number of threads. `julia -t 12`, for example would allow me to use up to 12 threads.
2. Add an `@threads` macro from the `Threads` package to the start of the loop:

```
Threads.@threads for i = 1:10
    println(i)
end
```

This looks straightforward because it is.
If you already have a bunch of CPU code, there is nothing easier than just slapping a `Threads.@threads` in front of the right loop and calling it a day.
But there's a reason I waited until the end of this chapter to introduce this concept.

The problem with looping is that it's inherently iterative.
That is to say that `i = 1` will come before `i = 2`, which comes before `i = 3`, and so on.
This is totally fine when we are talking about running code on a single core of a CPU, but let's face it.
No one is writing code for a single-core CPU nowadays because such computers essentially don't exist.
Nowadays, we really do care about parallelism.
`Threads.@threads` (or similar approaches from other languages) feels a bandage solution to transform an iterative method into a parallel one which can be misleading for students.

For example, let's look at the differences in the output from the two above loops:

| ------- | ------- |
| single-core | parallel |
| ------- | ------- |
| format | this |
| ------- | ------- |
2
1
10
8
5
9
3
4
7
6



The single core results look great, but the parallel ones are all jumbled up!
Why?
Well because the single core loop executed iteratively while the parallel loop executed in parallel.
This means that each `println(i)` statement was given to a different CPU core.
If the core was slightly faster (as in core `2`), it printed first.
If the core was slightly slower (as in core `6`), it printed last.
If the core was somewhere in the middle, it printed out somewhere in the middle.
For parallel loops, the output order is independent of the iterative count between 1 and 10.

I remember when I saw this for the first time, I was surprised.
In my mind, it shouldn't have mattered when the cores finished their operations.
The `for` loop should have naturally just output everything in the right order, regardless of when the computation was done!

The fact is that `Threads.@threads` is fundamentally changing the loop into something completely different.
We can't just slap that bad boy on anything.
When we use `Threads.@threads`, we need to think about the ramifications of parallelism in the very same way we would think about writing complex kernels and distributing that work to the GPU.
It's just now we *also* need to fight our own intuition on how these loops should function.
In addition, by relying on loops for parallelism, the code ends up being a large set of nested `for` loops, with one set of loops somewhere in the middle being parallel.
While it is usually quite clear how to parallelize kernels, the choice of *which* loop to parallelize over is sometimes difficult for beginner programmers.

At least in my experience, I have found that codebases using parallel extensions to inherently loop-based code all end up looking just as messy, if not messier, than the code that uses kernel-based approaches.
On the other hand, for programmers that know what they are doing, loop-based abstractions can still be quite helpful -- especially for code that already exists and would be a pain to rewrite.
There are also GPU languages (like Kokkos and SyCL) that use parallel loops by default, so it is good to know that such abstractions also exist in Julia for those who desire it.

### Loops on the GPU

