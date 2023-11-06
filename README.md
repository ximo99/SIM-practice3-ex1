# Simulation. Practice 3, exercice 1: the French billiards.
Simulation subject within the Multimedia Engineering degree from the ETSE - Universitat de València. April 2022. Practice 3, exercise 1. Rating 8. A French billiards must be simulated using a velocity-based collision model.

🎞️ Video with the result: [https://www.youtube.com/watch?v=xEUnrd95nZI](https://www.youtube.com/watch?v=f_A-oSXQdhY)

A velocity-based collision model must be implemented with its three steps:
  - Collision detection.
  - Restitution to the pre-collision position.
  - Calculation of the exit velocity.

To do this, a French billiards simulation must be implemented (without pockets), in which 5 balls are placed on a pool table, in initially random positions. The actual dimensions and masses of the balls and table of a French pool must be used. Once the balls are placed, the program will allow you to select one of them and simulate it being hit with a pool cue. The simulation of hitting will consist of modifying the instantaneous speed of the ball in the direction of the cue, so that, when moving, it bounces with other balls and/or with the edges (called bands) of the table and collisions occur. The interface chosen to choose the ball and use the cue is free, although it must be explained with a help message visible on the screen. The possibility for all balls to acquire random speeds and start moving simultaneously (with the M key) should also be implemented. Finally, it must be possible to choose (with the C key) whether collisions between the balls are computed or ignored, and it must be possible to reset the simulation (R key) so that a new arrangement of the balls is generated. Finally, to better check the stability of the simulation, the effect of attracting the balls towards an area of the table must be simulated, so that all the particles accumulate and constantly hit each other and the bands. For simplicity, we will model this effect as a constant force 𝐹𝑐 in a fixed direction pointing toward one of the corners of the table.
