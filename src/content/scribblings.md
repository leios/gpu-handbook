### A note on terminology

In order to do this, we need to create terminology for each stage of the process.
Keep in mind that each stage of this process also has it's own memory associated with it.
Threads have memory.
Groups of threads have more memory.
GPUs, in general, have memory.
Unfortunately, the naming conventions here get a little screwy and depend on which programming interface you are using, so let's write it all down.

| Hardware concept | CUDA terminology | KernelAbstractions Terminology |
| ---------------- | ---------------- | ------------------------------ |
| Core             | Thread           | WorkItem                       |
| Core memory      |                  |                                |
| Group of cores   | Block            | WorkGroup                      |
| Group memory     | Shared           | Local                          |
| All cores        | Grid             | NDRange                        |
| All memory       | Global           |                                |

To be clear: KernelAbstractions terminology is largely inspired from OpenCL.
In this case `NDRange` means an $$N$-dimensional range to iterate over.
At this stage, it's probably a little confusing and overwhelming, so it might be good to refer back to this table as we have more practical examples.

To keep all this straight, it is important to think about this from the thread's perspective.
Each thread has access to:

1. A small memory bank to hold local data. This is often called "local memory."
2. A slightly larger memory bank to hold data of all threads running at the same time in a "block". This is called "Shared memory."
3. An even larger memory bank that holds all available GPU memory. This is called "Global" memory.

Mention that we can use CUDA.jl or AMDGPU.jl
