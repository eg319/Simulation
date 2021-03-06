from Star import * #Imports all information from Star.py
from Quadtree import * #Imports all information from Quadtree.py

stars = generateStars(10) #Decide the number of stars
tree = Quadtree() #Creates the Barnes-Hut tree object

def setup(): 
  size(1000, 700) #Define the size of the canvas

def draw():
    background(0) #Defines background colour (0=black)
    updateStars(stars) 
    #com(stars) #Showing the stars in the Centre of Mass frame. This makes it simpler to watch, because the stars don't fly off as quickly. Hash this out for lab frame
    tree.buildTree(stars) #Builds the tree with the stars as elements of the tree.
    
