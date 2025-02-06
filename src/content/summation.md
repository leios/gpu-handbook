# Summation is nontrivial

Let's create a vector of ones and sum them all together:

```
julia> a = ones(10);

julia> sum(a)
10.0
```

Cool.
Now let's do it in parallel.

## Our goal

1. Show scaling (`scaling.jl`)
2. Show that GPU is slower until 2^22 ~ 4,000,000 elements
3. BUT! It *is* faster. How is that possible?

Let's write down a function that will 

Plot sum on Array and GPU Array for different matrix sizes.
We are trying to get as close as possible to the GPU curve.

## We have the tools already

Vector addition over and over

## Some final thoughts

Complexity notation vs benchmarks.

The first problem that gets students to think about how to properly use their GPU.


