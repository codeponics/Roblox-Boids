﻿# Roblox-Boids
Made in May 2020

An experiment project that spawns random balls with velocity vectors to simulate flying birds and then uses the boid algorithm to simulate flocking in Roblox Lua.

![](https://github.com/codeponics/Roblox-Boids/blob/main/demo.gif)

Funny story: I was agonizing over why my tests weren't working and why my "birds" were acting sporadic and flying without going near each other. I went through months just never finding out, only to figure out right now in 2024, 4 years later, that I simply forgot to turn up the POV size. I severely overestimated the measurement of a "stud", which is what Roblox measures in coordinate-wise.

Just by updating the POV size to 100 studs rather than 10 studs, the flocking algorithm worked as expected.

This was one of my most fun projects when I got deeper into game development algorithms as it was elegantly simple.
It is a little bit old so it can be made more efficient with newer Roblox API now.

# Boid Rules
A boid will be considered a bird that is apart of the flocking algorithm.
Boids fly in random directions by default through a choice algorithm of however you want them to fly.
I use perlin noise (math.noise) instead of pure pseudorandom numbers to control my boids' flight directions.

Alignment: aligning to other boids, flocking aspect

Cohesion: floating towards a center of mass between boids when flocking

Separation: prevents boid collision with each other (FOV aspect)

# How to Use
Import Boids.rbxm into a .rblx place file making sure there is a Baseplate object.

Click Run and use your camera to watch the magic show begin.

You can change the parameters of the agent in the BoidsModule.lua file of the four variables at the top.

I recommend keeping the maxForce as it is.

One of my other projects used Luau, this does not require Luau but is compatible with.

# How to Improve
If you're looking to use it with up to date Roblox games and do care about performance,
you'll have to refactor the code so the coroutine wraps for each new boid is reimplemented
into a RunTime.Heartbeat loop that is iterating over the boidsList.

At the time, I made the decision to just spawn processes for each boid which probably isn't healthy in the long run.

You should also convert all wait into task.wait as that is what Roblox likes to use now and "wait" is now a relic of the past being kept for backwards-compatibility and old scripts like mine.

# License
MIT License
