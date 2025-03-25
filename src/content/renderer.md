# A Simple Renderer

In the introductory chapter, we briefly discussed the differences between graphical and computational programming interfaces for GPUs.
At the time, I openly stated, "If you are interested in building a game or rendering engine, it might be best to think of this book as a way to satiate some idle curiosity that might be lingering in the back of your head."

That statement is still true.
Computational fluid dynamics is quite different than the physics of water in video games.
The former typically involves rigorously solving a set of complex partial differential equations on an appropriately-sized mesh to solve a specific engineering problem.
The latter could be anything, as long as it fits the artistic style necessary for the medium and doesn't hurt the application's overall performance.
Both of these groups are trying to solve different problems.
Even more simply: one wants to be as accurate as possible, while the other wants to use the least resources while still providing a decent final result.

It is also true that graphical interfaces have been around for a lot longer than computational ones.
OpenGL (The Open Graphics Language), for instance, was initially released on June 30, 1992.
CUDA was released on February 16, 2007.
At this stage, both graphical and computational interfaces are relatively mature, but it could be said that some of the graphical interfaces are starting to show their age.

Though this book primarily focuses on GPU computing, it is still important to talk about graphical workflows because:
1. Historically, graphical applications have been the primary driver of GPU technology. Though this has changed recently with many people using GPUs for cryptocurrency mining and machine learning.
2. With a better understanding of traditional graphics interfaces, it becomes easier to integrate computational workflows into a broader class of applications.
3. It is possible to do computation with graphically-oriented interfaces.
4. It is possible to do graphics with computationally-oriented interfaces.

This chapter will tackle point 4 above.
After all, we have just learned how to do broadcasting and write out a kernel.
Now it's a good idea to take a second and do something both visual and interesting with that knowledge.
In particular, we this chapter will be our first adventure into a field known as "softwre rendering," which is the act of using non-traditional graphics workflows (in this case, GPU computation) to render an image, video, or other application.

So let's start by talking about graphics: how it works with traditional interfaces and how we can emulate the same behaviour with compute kernels.

## The graphics pipeline

Like in the computing landscape, there are also a bunch of different graphical interfaces that are used by different groups for different purposes:

* **DirectX** is a Microsoft-proprietary interface used for game development and has been the standard for ages. It is part of the reason Windows is so dominant in the gaming space.
* **OpenGL** is the "Open Graphics Language" and is the sister langauge to OpenCL, the Open Compute Language. They share similar strengths and weaknesses. OpenGL is a little more annoying to use and therefore much less common than other tools.
* **Metal** is an Apple-based proprietary interface for mac devices. We have mentioned it before because it is also the interface Julia is using under-the-hood for computation on Mac devices.
* **Vulkan** is a new interface developed by Khronos (the same group as OpenCL and OpenGL). It is a little lower-level when compared to OpenGL, but aims to dust off a load of technical debt that has accrued over decades of comtinuted development of OpenGL.

Though all these interfaces are different, they generally follow the same guiding principles from start to finish.
It is also important to note that these guiding principles are more restrictive than those used for computation.
That is to say that almost all graphical interfaces are split into two stages: the construction and movement of vertices within a mesh, and the coloring of that mesh.
In the case of graphical applications, the functions that are written to do this work are similar to compute kernels, but called "shaders" instead.
An example set of available shaders can be seen in the following image:


ADD FIGURE OF WORKFLOW + DESCRIPTION OF EACH STEP

But what if your graphical application does not need a mesh?
That's actually a really good question.
There are plenty of approaches that can do a lot with simply fragment shaders.
Inigo Quillez, for example, has made a name for himself doing signed distance field visualizations, which is a cousin to raytracing and can be done without a mesh.
There are also a large number of point-cloud representations that have become popular in recent years for techniques known as "Gaussian Splatting" and LIDAR for autonomous vehicles.

## A simple shader

## Now let's animate!

## Downsides of this approach

No access to pixel buffer
Pixar used this approach with render farms for a large number of their movies when they introduced raytracing in monster's inc.
