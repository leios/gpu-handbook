# Summation is nontrivial

In the last chapter, we discussed several core abstractions that can be used for GPU computation, and showed off an example with a 1000x performance boost from the GPU (when compared to its single-core CPU counterpart).
At that time, I mentioned that we cannot hope to achieve the same speed up for all cases and that there are certain problems the GPU is uniquely ill-suited to solving.
In particular, the GPU most useful when we can decompose our problem into itty-bitty bite-sized chunks of computation that can be spoon-fed to each GPU core.
Such problems are known as "embarrassingly parallel," though I don't know if I fully agree with the terminology.
I mean, what's embarrassing about ...

We need to reformulate certain problems so they can become embarrassingly parallel.

The problem is that many (maybe even most) problems are not embarrassingly parallel and it's not trivial to figure out how to distribute the work to multiple cores.
In this chapter, I will introduce one such example.
A problem that is stupidly straightforward on the CPU and a pain in the butt on the GPU: summation

Let's create a vector of ones and sum them all together:

```
julia> a = ones(10);

julia> sum(a)
10.0
```

Cool.
Now let's do it in parallel.

Take a second and think about how you might do this.
Seriously.
Don't read the next paragraph.
Think about how you plan to parallelize this.

## Our goal

Because summation is such a common request from programmers, Julia provides a `sum` function for both CPU and GPU arrays...

1. Show scaling (`scaling.jl`)
2. Show that GPU is slower until 2^22 ~ 4,000,000 elements
3. BUT! It *is* faster. How is that possible?

Let's write down a function that will 

Plot sum on Array and GPU Array for different matrix sizes.
We are trying to get as close as possible to the GPU curve.

## We have the tools already

Vector addition over and over

## Some final thoughts

* Complexity notation vs benchmarks.
* The first problem that gets students to think about how to properly use their GPU.
* Accumulation / prefix sum


