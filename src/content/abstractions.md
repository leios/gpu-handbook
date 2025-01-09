# All the Ways to GPU

An abstraction is a metaphorical device used to make a complex task simpler to understand.
We use abstractions *everywhere* in programming.
Examples include: `for` and `while` loops, functions, structures and classes, etc.
Basically every common programming device we use is an abstraction of some form.
In this chapter, I will introduce many common abstractions that can be used to perform GPU computation, but let's start at the start...

## Installation

As mentioned in the introduction, we will be using the Julia language for this book, so the first step would be to install Julia.
It is important to note that this book is intended for those who already have some (at least limited) familiarity with programming.
As such, I will keep the installation instructions brief.
If you are already used to programming, you probably already have your own preferred development workflows all sorted out and will just google for similar solutions with Julia.

For most users, installation involves going to the website [https://julialang.org/downloads/](https://julialang.org/downloads/) [^1] and following the instructions.
For most users, this means that you will need to open up the terminal (or shell on Windows) and run the provided command.
Once you have Julia installed, you then need to decide how you want to edit your code:

1. With text editors. This means you will use your text editor of choice (for example: vim, nano, notepad++) and then manage all of your code on your own. You might want to google around for most common options with Julia.
2. With development environments. These are collections of all the things programmers typically need for development packaged into one graphical interface. The most common one for Julia is VSCode, with full installation instructions found here: [https://code.visualstudio.com/docs/languages/julia](https://code.visualstudio.com/docs/languages/julia)[^2].

Keep in mind that if you are *not* using Julia and have instead decided to rewrite the code in this book in another language, the installation might be significantly different and potentially more complicated.

[^1]: https://julialang.org/downloads/
[^2]: https://code.visualstudio.com/docs/languages/julia](https://code.visualstudio.com/docs/languages/julia

## Your first GPU Array

Now that we have Julia installed, we can start using our GPU!
As I discussed in the introduction, the current state of GPU programming is (unfortunately) quite fragmented, so the first step is to identify the hardware on your system.
Ideally, you already know this information (because you bought or built your own computer and can look at the specifications), but here's some hints to figure out what you have depending on your operating system:

* **Windows**: Go to the "Device Manager" and look under "Display Adaptors", where you should find the manufacturer of your GPU.
* **Mac**: Go to "About this Mac". If it says you are running an "Apple M$$x$$" chip, where $$x$$ is some number, then you can use your Apple Silicon GPU.
* **Linux**: To be honest, there are a bunch of different ways to figure out what hardware you are running, so feel free to google and use your preferred method. My go-to is always `lspci | grep "VGA"`, which will tell you what GPUs you have.

In the case you have more than one GPU available, feel free to use whichever one you want (or all of them).
If you do not have a usable GPU, that is totally ok!
Instead, you can use your CPU with Julia's basic `Array` type.

If you could not figure out whether you have a usable GPU at this stage, that's also totally fine.
We can use Julia to figure out which packages will work on your machine.
More on that in a moment.

For now, let's talk about the Julia packages available for your hardware:

| Hardware Available | Necessary Package | Array Type |
| ------------------ | ----------------- | ---------- |
| Parallel CPU       | none              | Array      |
| NVIDIA GPU         | CUDA              | CuArray    |
| AMD GPU            | AMDGPU            | ROCArray   |
| Intel GPU          | oneAPI            | oneArray   |
| Apple Silicon      | Metal             | MtlArray   |

Keep in mind that the package names here follow the naming conventions for the traditional software tooling of your hardware.
Julia's package for NVIDIA GPUs is `CUDA`, because it is essentially a wrapper for CUDA (A C language extension for NVIDIA GPU tooling) in Julia.
At this point, if you already know your GPU hardware, simply install the relevant package by using the following commands:

1. `julia`: This will open the Julia shell (called the REPL, which stands for "Read, Evaluate, Print, and Loop"). You should see an ASCII Julia logo appear and then a green `julia>` prompt.
2. Press the `]` key: This will open up the package manager and change the prompt to something like `(@v1.10) pkg>`. It will also change the color to blue.
3. `add GPUBackend`: Where `GPUBackend` is the appropriate package. For example, I have an AMD GPU, so I will `add AMDGPU`. If I were runnig an M2 mac, I would `add Metal`. If I had an NVIDIA GPU, I would `add CUDA`. Keep in mind that this might take some time because it's installing a lot of GPU driver magic in the background.
4. Press backspace: This will leave the package manager
5. `using GPUBackend`: This will load the package in the Julia REPL. This might take a second as it's compiling everything for the first time.
6. `GPUBackend.functional()`: This will test to make sure the package will work on your machine. It *should* return `true` if you have the right hardware available.

If `GPUBackend.functional()` returns `false`, then there is something wrong with the configuration.
That is absolutely no problem for the purposes of this text, as you can simply use parallel CPU execution instead of the GPU; however, it might be worth googling around to try to figure out why your GPU is not working (and maybe even create an issue on github for the appropriate package if you feel your GPU *should* be supported, but isn't).

!!! tip "But what if I don't know my hardware?"
    In this case, just install all the packages and test them all.
    Remember, use `]` to enter the package manager (`(@v1.10) pkg>`) and backspace to return to the Julia REPL (`julia>`):
    ```
    (@v1.10) pkg> add AMDGPU CUDA oneAPI Metal
    julia> using AMDGPU, Metal, oneAPI, CUDA
    julia> AMDGPU.functional()
    true
    
    julia> Metal.functional()
    false
    
    julia> oneAPI.functional()
    false
    
    julia> CUDA.functional()
    false
    ```
    Here, I have a working AMD GPU, but none of the other vendors will work.
    I omitted a few error messages that appeared on my machine when `using Metal` and `using oneAPI` as not all users will experience those errors. They both informed me immediately that my hardware was not supported, so I did not need to run `.functional()` on those packages.
    
    After you have found the appropriate package on your machine, feel free to remove the unnecessary ones with:
    
    ```
    (@v1.10) pkg> rm GPUBackend1 GPUBackend2 GPUBackend3 ...
    ```

!!! tip "But what if I can't (or don't want to) use the package mode (`]`)?"
    You can actually use the package manager as a package, itself, so...
    ```
    julia> using Pkg
    julia> Pkg.add("GPUBackend")
    ```
    Where `GPUBackend` comes from the table above.

!!! note "Reviewer Notice"
    I actually think the `using Pkg` method is more straightforward for beginners. Should we do that one by default and have a separate tip to explain the `]` package management mode?
    
    I introduced `]` first because (let's be honest) that's how the majority of people interface with the package manager; however, `using Pkg` is necessary for scripts and CI, so it is also important to know.
    
One core difference between CPU and GPU programming is in how users think about the code.
For the CPU, users typically think about the number of operations each core is performing.
Though you still need to consider this with the GPU, calculation speed is often not a huge bottleneck to GPU performance.
Instead, GPU programmers need to think about data flow.
That is, where the your memory is in GPU memory.

As a rule of thumb, the slowest part of any computation is communication -- specifically communication between the CPU and GPU, but also communication with different types of memory on the GPU.
We'll be discussing the latter case in more detail with specific examples later.
For now, let's just create an array and pass the data to the GPU.

```
julia> a = zeros(10, 10)
julia> b = ArrayType(a)
```

Lot's of things to talk about.
`zeros(...)` is a Julia method to create an array that is all 0 of a particular size. Here, it's 10 by 10.
This command will create an `Array` object whose memory exists "on the CPU".
More accurately, the memory will sit on the motherboard RAM, a convenient location for CPU operations.
We then need to send that data to the GPU with `ArrayType(a)`.
Here, `ArrayType` is the array type from the table above.
For example, those with an AMDGPU would use `ROCArray`.
Those with an NVIDIA GPU would use `CuArray`.
Those with Apple Silicon would use `MtlArray`.

It is important to note that the command `ArrayType(a)` is actually doing two things at once:
1. Allocating the appropriate space on the GPU
2. Copying the data from the CPU to GPU.

In Julia, these two steps are often coupled, but the don't need to be.
We could have created the same GPU array by running:

```
b = GPUBackend.zeros(10,10)
```

This would avoid the (relatively) costly communication between the CPU and GPU.
Most of the array creation routines (such as `rand(...)`, and `ones(...)` have similar routines for each backend for simplicity.

!!! tip "A note about Macs"
    If you are running a Mac, you might not have been able to create your array on the GPU.
    This is because Metal (the API used for GPU computation on Apple Silicon) only supports single precision (`Float32` for example).
    So to create the necessary array on a mac, specify the type for `zeros(...)` first, like so:
    ```
    julia> a = zeros(10, 10)
    julia> b = MtlArraya)

    ```

### Expected performance from Julia

Ok, it's important to talk about some pitfalls to using Julia.
After the installation, there are probably two distinct groups of people:

1. Those that are new to GPU programming: These people are probably scratching their head at all the new, unnecessary packages. After all, they just want to use their GPU! Why do they need to think so deeply about their hardware?
2. Those who have attempted GPU programming before. These people are probably amazed at how easy the installation was. Julia *just did everything for us* in a way that seems like magic!

There is a little truth to both of these claims.
Yes, Julia does a lot of the heavy lifting for the user.
And yes, there is still a lot of jank we are trying to get rid of.

But there's another (potentially ill-formed) thought that might be lurking in the back of your mind, "If all these Julia packages are just wrappers to C, why not use C instead? Won't we get a performance penalty for using Julia in this case?"

That's a very good question, and it's difficult to fully explain.
Long story short, Julia boils down to the same lower-level representation as C (if you are using the clang compiler), so it should be equivalently fast.
It can also call C code without any performance penalty, so the wrappers should be equivalently fast.
But there is a cost!
In fact, you have already experienced it.

When you ran `using GPUBackend` and `ArrayType(a)` above there was some noticeable delay while Julia was getting the code up and running (precompiling).
If you run the same commands again, they should be super fast.
Let's check this out with the `@time` macro provided by your GPU backend:

```
julia> a = zeros(10,10);

julia> GPUBackend.@time ROCArray(a);

julia> GPUBackend.@time ROCArray(a)
```

For me, this looks like:

```
julia> a = zeros(10,10);

julia> AMDGPU.@time ROCArray(a);
  1.676601 seconds (7.35 M allocations: 508.234 MiB, 14.36% gc time, 85.91% comp
ilation time)

julia> AMDGPU.@time ROCArray(a);
  0.000370 seconds (12 allocations: 368 bytes)
```

The second run was literally 4,500 times faster! Also take a look at the information in parentheses.
The first run had 7.35 million allocations and spent 85% of it's time precompiling.
The other roughly 15% of time was spent on garbage collection.
The second run had 12 allocations and no time at all on garbage collection or precompilation.

It is really important to keep in mind that Julia can (and should) get comparable performance to C in most cases, but you need to give it a second to precompile everything first.
Even though many people in the Julia community are working on decreasing precompilation time, it is unlikely that this will go away entirely any time soon.
If your specific GPU project requires fast recompilation regularly (which is the case for some graphics workflows), then you might need to take the lessons from this book and translate them into another language in the future.

That said, I truly believe that Julia provides the most flexible ecosystem for most GPU workflows and should be a greate starting language for any GPU project.
In particular, it is the only language that provides so many different abstractions for doing GPU computation.
It's time to talk about them in detail, starting with...

## Array-based operations

Ok, now we have a GPU Array. What can we do with that?
Well, a lot actually, but let's start with the basics.

### Indexing

Indexing is the act of accessing array memory one element (index) at a time.
On the CPU, you might create an array, `a`, and get the first index with `a[1]`.
It might be reasonable to assume that similar logic would work on the GPU, so let's try it:


```
julia> using GPUBackend

julia> a = ones(10,10);

julia> b = ArrayType(a);

julia> a[1];
1.0

julia> b[1];
ERROR: Scalar indexing is disallowed.
Invocation of getindex resulted in scalar indexing of a GPU array.
This is typically caused by calling an iterating implementation of a method.
Such implementations *do not* execute on the GPU, but very slowly on the CPU,
and therefore should be avoided.

If you want to allow scalar iteration, use `allowscalar` or `@allowscalar`
to enable scalar iteration globally or for the operations in question.
Stacktrace:

...

```

As a reminder, `GPUBackend` and `ArrayType` depends on your hardware and can be found in the installation section.

But what's the deal?
Why can't I access elements of my GPU array?
What does "scalar indexing" even mean?

Simply put, scalar indexing is the act of accessing an array one element at a time, for example `a[1]`, `a[2]`, or `a[i]`, where `i` is some integer value.
As to why this is not allowed on the GPU, well... there are a bunch of factors all working against each other to make scalar indexing difficult.
Remember, the GPU is a separate device that is built to solve a lot of simple operations at the same time.
This means that:
1. GPU memory is not "on the CPU", so we can't display it without first transferring it to the motherboard RAM. We could display a single element of `b` (with `b[1]`) if we were to first transfer it back to the CPU with `Array(b)`
2. The GPU is not meant to do only one thing, but a bunch of things at once. When we are asking the GPU to display a single element with `b[1]`, we are doing something incredibly inefficient from the GPUs perspective.

Item 2 is the reason why GPU backends in Julia do not allow users to access GPU arrays one element at a time.
Simply put, if users are using the GPU one index at a time, it's going to be really, really slow, so we need to do what we can to discourage that behaviour whenever possible.
If you find yourself in a situation where you need only a single element of a GPU array, then it is best to first tranfer it to a CPU array before doing anything with the data.

!!! tip "But what if I *really* need scalar indexing"
    Keep in mind that if you *really* need to access a single element of a GPU array, you can do it by first setting the `allowscalar` flag `true` (and then turning it off again afterwards):
    ```
    julia> GPUBackend.allowscalar(true)
    ┌ Warning: It's not recommended to use allowscalar([true]) to allow scalar indexing.
    │ Instead, use `allowscalar() do end` or `@allowscalar` to denote exactly which operations can use scalar operations.
    └ @ GPUArraysCore ~/.julia/packages/GPUArraysCore/GMsgk/src/GPUArraysCore.jl:188
    
    julia> b[1]
    1.0
    
    julia> GPUBackend.allowscalar(false)
    
    ```
    
    You can also wrap the necessary code in a `do` block, like so:

    ```
    GPUBackend.allowscalar() do
        b[1]
    end

    ```
    Or use the provided macro
    ```
    GPUBackend.@allowscalar b[1]
    ```

So now that we've shaken everyone up a little bit by talking about something that is simultaneously trivial on CPUs and next to impossible on GPUs, let's talk about things we can *actually* do with our GPU array.

In the next few sections, I will be introducing three different abstractions that are commonly used for GPU programming:
1. Broadcasting: the act of applying the same command to every element in an array.
2. GPU functions (called kernels): the act of writing a specific function that gives instructions to each GPU core
3. Loop vectorization: the act of transforming a `for` or `while` loop for GPU execution.

Before going further, it's worth noting that these abstractions are not available for all languages.
For example, CUDA and OpenCL focus almost exclusively on user-defined GPU functions.
SyCL and Kokkos focus on loop vectorization.
Julia is unique in that all three of these major abstractions are deeply ingrained into the ecosystem as a whole and play very nicely not only with each other, but the broader Julia ecosystem.

If you are planning on rewriting all the code in ths book with another language, it might be a good idea to first jump to the abstraction that works well in the language you have chosen and then come back to the other sections as needed.
For now, I intend to cover things in the order that feels most intuitive for GPU computation, starting with...

### Broadcasting

Ok.
I get it.
Most programmers have probebly never used broadcasting.
Before using Julia, I certainly hadn't.
So let's start at the start.

To reiterate, *broadcasting* is the act of applying the same command (broadcasting in the colloquial sense) to every element in an array.
Though accessing individual elements of a GPU array is a little complicated, applying the same operation to all elements of an array is surprisingly easy -- in fact, it's perfect for the GPU!

So let's look at some basic syntax:

```
julia> a = zeros(10)
10-element Vector{Float64}:
 0.0
 0.0
 0.0
 0.0
 0.0
 0.0
 0.0
 0.0
 0.0
 0.0

julia> a .+= 1
10-element Vector{Float64}:
 1.0
 1.0
 1.0
 1.0
 1.0
 1.0
 1.0
 1.0
 1.0
 1.0

```

In Julia, the `.` before some command indicates to the compiler that the user would like to broadcast the command to all elements of an array.
So, these lines:
1. Created an array of ten zeros, called `a`.
2. Broadcasted the `+= 1` command to each element of the array, indicated with `.+= 1`

As long as you are can write your GPU code as broadcasted operations, it should be possible to execute that code on the GPU.
For example, the following will also work:

```
julia> using GPUBackend

julia> a = GPUBackend.zeros(10);

julia> a .+= 1
10-element ArrayType{Float32, 1, ...}:
 1.0
 1.0
 1.0
 1.0
 1.0
 1.0
 1.0
 1.0
 1.0
 1.0

```

And there you have it!
You've just executed your first function on the GPU.
But we probably want to do things way more complicated than just adding one to every element of an array, so let's look at a few quick examples of broadcasting in practice.

#### Adding one to every odd element

We just added one to every element.
What if we want to do the same, but for every *odd* element?
To do this, we need to define a custom *range* for accessing our Julia array.
For example, if we want access only the first five elements of an array, we might use the range `1:5`.
If we want to choose every other element, then we would go in steps of two, so `1:2:5`.
Putting this together, if we want to add one to every odd element of an array, we might do...

```
julia> a = zeros(10);

julia> a[1:2:10] .+= 1;

julia> a
10-element Vector{Float64}:
 1.0
 0.0
 1.0
 0.0
 1.0
 0.0
 1.0
 0.0
 1.0
 0.0

```

And that's that.

Now for a few quick exercises to make sure we understand everything:

!!! todo "Problem 1: Do it on the GPU"
    Do what we just did on your GPU backend. In other words, change the array type of `a` to your `ArrayType` and add one to every other element

!!! todo "Problem 2: Subtract 1 from every even element"
    Create some broadcast operation that will subtract one from every even element

!!! todo "Problem 3: Square each element of the array"
    For context, `x^y` is the math operator in Julia to "raise some number (`x`) to the power of some other number (`y`).
    So the squaring operator in Julia for a single value would look like `x ^= 2`.
    
    Now broadcast that operation to your entire array.

#### Vector addition

When it comes to GPU computation, there is a single problem that every single person does to make sure their code is working as intended.
It is so common, that the problem is often called the "'Hello World!' of GPU computation.
That problem is vector addition, the act of adding two vectors together.
Let's do it with broadcasting.

```
julia> a = rand(10)
10-element Vector{Float64}:
 0.3446361752270596
 0.6044872863666282
 0.8081681226442919
 0.6586667828785924
 0.23172116207667204
 0.08632001843030668
 0.09675977506693823
 0.6771842850312151
 0.019671351328815923
 0.7149572102336769

julia> b = rand(10)
10-element Vector{Float64}:
 0.30677966842793747
 0.27954729235962206
 0.37278805220786826
 0.7667780614002805
 0.9295691111986113
 0.6457830807742259
 0.4943043624323966
 0.8731592407550742
 0.3415622970290325
 0.32403477239711587

julia> c = a .+ b
10-element Vector{Float64}:
 0.651415843654997
 0.8840345787262502
 1.1809561748521602
 1.4254448442788727
 1.1612902732752834
 0.7321030992045325
 0.5910641374993348
 1.5503435257862894
 0.36123364835784844
 1.0389919826307927
```

So there's a lot to unpack here.
Firstly, broadcasting can work in general on the right-hand side of any math equation.
Secondly, `rand(...)` works the same way as `zeros(...)` or `ones(...)`.
Right now that might seem trivial, but random numbers are actually a little hard to right on GPUs, so we'll talk about that in a little more depth later.
Thirdly, it's important to note that `a` and `b` must be the same size for this to work, so make sure that's true before brodcasting operations to more than one array.

But there's a more subtle point here that many people might have missed, and it has to do with the third command, `c = a .+ b`.
Simply put, `c` did not exist before running the command!
This means that we have created a new array for the sole purpose of adding `a` and `b`.

Though this might not seem particularly noteworthy on the CPU, it actually has large implications for the GPU.
Remember that the slowest part of most computation is memory management, and here, we have allocated space for and assigned the values of a random array without even considering the consequences to performance!
If at all possible, we want to minimize the number of times we create new arrays.

So how might we rewrite things so that we don't unnecessarily allocate `c`?
Well, the simplist solution is to allocate it at the same time as `a` and `b` and then use `.=` instead of `=`:

```
julia> a = rand(10);

julia> b = rand(10);

julia> c = similar(a);

julia> c .= a .+ b
```

Here, we use `similar(a)`, which will create an array that is the same size and shape of `a`, which should (hopefully) also be the same size and shape of `b`.
The data in `c` from `similar` will be just whatever junk was in memory at the time and won't necessarily be all zeros or anything.
That shouldn't matter because `c` is used exclusively for output, so there's no reason to invoke `rand(...)` if we don't need it.

There are actually distinct terms to distinguish between the two different types of computation we did:
1. **In Place** computation is when all operations act on *already existing* data.
2. **Out of Place** computation is when some operations *create new data*.

So `c = a .+ b` was *out of place*, while `c .= a .+ b` was *in place*.
It's important to keep this in mind for later.
Remember that data flow *really* matters with GPU computation, so it's doubly important to make sure you know where your data lives.

A quick note.
I would like to believe that *every single Julia programmer* has been tripped up by the difference between `=` and `.=`.
I certainly have torn my own hair out late in the evening, trying to figure out why the performance of my code is so slow, only to realize I forgot a single `.`, and was accidentally allocating a bunch of memory I didn't need to.
It happens to the best of us, which is why I am pointing it out now while you are young and impressionable.
Julia syntax sometimes looks sleek, but there's a lot of power under-the-hood, so it is wise to take a second and make sure every line is actually doing what you want. 

I think that's it for now.
On to some problems.

!!! todo "Problem 4: Try to add arrays of different sizes"
    ... and see the error message

!!! todo "Problem 5: Do it on the GPU"
    Create three arrays, `a`, `b`, and `c`, all of type `ArrayType` for your specific GPU backend. Add `a` and `b` together and write them to `c`.
    You may create `a`, `b`, and `c` in any way you wish, but it might be more interesting to use `ones(...)` or `rand(...)` instead of `zeros(...)` because $$0 + 0 = 0$$.

!!! todo "Problem 6: Add the first five elements of `a` to the last five elements of `b`"
    Create custom ranges so you can add one through five of `a` to five through ten of `b`.
    Remember that your output array (`c`), should be five elements this time!


#### Broadcasting generic functions

Until now, we have been broadcasting pre-defined Julia functions (mainly math operations), but what if we wanted to broadcast our own (user-defined) functions?
Well, let's do that.
Let's say we wanted to get ten numbers between one and one-hundred.
We might create a function that looks like this:

```
julia> f(x) = round(Int, x*100)
```

This would take some input (`x`), multiply it by one-hundred, and then round it to the nearest integer value (`Int`).
So `f(0.5)` is `50.
`f(0.6542)` is `65`.
And so on.
Now let's broadcast that function to an array of random numbers:

```
julia> a = rand(10);

julia> f.(a)
10-element Vector{Int64}:
 15
 46
 12
 11
 15
 13
 13
 60
 89
 89

```

Here, we've used the `.` operator to signify that we want the function broadcasted along all elements of the first argument of `f`.
So let's create another function to do the vector addition from the previous section:

```
julia> g(a, b) = a + b
g (generic function with 1 method)

julia> a = rand(10);

julia> b = rand(10);

julia> c = similar(a);

julia> c .= g.(a, b)
10-element Vector{Float64}:
 1.1339661653178916
 0.9405969685936231
 1.576334145965099
 0.6608638707221182
 1.2142578652057847
 1.3606689325191113
 0.7669673576476489
 1.7838687185111035
 1.370863980086035
 1.5491853434156098

```

There are actually many different ways we could have done that.
For example, we could have made `g` use `c` as an argument and then used `g.(c, a, b)`.
Feel free to explore if you want.
In fact, I actively encourage it.

I think it's also important to also show off a slightly more powerful function.

ADD MORE

#### A simple exercise: "Where did the noise go?"

As an interesting note, when timing the vector addition on the CPU and GPU, you might notice that the CPU is faster.
This might cause you to scratch your head and wonder, "Well, what are we doing this for then?"

So here's a simple example of where

#### Some room for development

So here's a weird quirk of the Julia ecosystem.
Even though broadcasted operations performed on a GPU array are done in parallel by default, the same is not true for traditional CPU `Array`s.
To be doubly clear, this will be executed in parallel:
```
a = GPUBackend.ones(100)
a .+= a
```
but this will not:
```
a = ones(100)
a .+= a
```

There are a lot of good reasons for why this is the case.
Some of it comes down to engineering time.
Some of it comes down to active research questions regarding the proper procedure to distribute generic operations in parallel.
For the purposes of this book, none of that matters because we are talking about GPU execution, specifically.

It's just good to point out that there are certain areas within the Julia language that people are working on, but are not fully finished yet.
In fact, there are a bunch of similar stories throughout the GPU ecosystem and I will try to point these out as they come up.

#### Final musings on broadcasting for GPU computation

A few years ago, I had just started working at MIT, and I was excited to see what people were actually using the GPU ecosystem in Julia for.
I came across an ocean simulation project with incredibly enthusiastic developers.
It was fast and intuitive to use.
I was shocked when I found out that they had written their entire codebase solely using broadcasting.

And why shouldn't they?
Broadcasting provides a hardware-agnostic method for performing almost any mathematical operation!
If you are exclusively crunching numbers, then there is almost no better abstraction than writing down the math and adding a few `.`s here and there.

Yet, after a few years, they sought even better performance and eventually rewrote their code using GPU-exclusive functions (kernels), which will be introduced in the following section.
Simply put, broadcasting is an absolutely excellent way to get started with GPU computation in Julia.
It's an intuitive abstraction and will get you *most* of the performance you need from the GPU.

But there's a reason this work is called the *GPU **Kernel** Handbook*.
When you need true flexibility or better performance, there is no better abstraction than writing functions specifically for the GPU.

## GPU Functions: Kernels

Mention that we can use CUDA.jl or AMDGPU.jl

## Loops 

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

But also, isn't it a little strange that we need to specify that something happens in parallel to begin with?
Like, if we have data on an Array and we have mutiple threads available, why isn't it parallel by default?

The `for` loop is an overloaded expression that does completely different things depending on what it's "iterating" over.
In some cases, it's not even iterating at all!

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
| 1 | 2 |
| 2 | 1 |
| 3 | 10 |
| 4 | 8 |
| 5 | 5 |
| 6 | 9 |
| 7 | 3 |
| 8 | 4 |
| 9 | 7 |
| 10 | 6 |

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

