# -*- coding: utf-8 -*-
import numpy as np
#List of way to rotate the cube's faces
turn = ['F', 'L', 'R', 'U', 'D', 'B']
#Add anti-clockwise rotations to the list
lastindex = len(turn) - 1
for x in turn:
    if turn.index(x) <= lastindex:
        x = x + "'"
        turn.append(x)

#Generate 25 random ways of turning to scramble the cube
scramble = []

while len(scramble) < 25:
    i = np.random.choice(turn)
    if len(scramble) == 0:
        scramble.append(i)
    #To ensure that the current turn does not undo the previous turn
    elif scramble[-1][0] != i[0]:
        scramble.append(i)
    elif i == scramble[-1]:
        scramble.append(i)
        
print(scramble)