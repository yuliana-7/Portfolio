This is a python script I made to simulate ways to scramble a solved Rubik's Cube. 

When the script is run, it generates 25 random moves to help shuffle the cube in an unbiased way to prevent cheating. 

It uses the numpy package to pick a random item from the list of possible ways to rotate the cube's faces, and a while loop to repeat the process until the list consists of 25 moves.

Conditions were added to prevent a situation where a clockwise rotation is followed by an anti-clockwise rotation (or vice-versa), which would return the face to the initial position.

Notation:

* F = Front
* L = Left
* R = Right
* U = Up
* D = Down
* B = Back
* ' = Anti-clockwise
