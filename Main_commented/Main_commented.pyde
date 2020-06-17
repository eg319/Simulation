from Star import * #Imports all information from Star.py
from Quadtree import * #Imports all information from Quadtree.py
stars = generateStars(nStars) #Decide the number of stars
tree = Quadtree() #Creates the Barnes-Hut tree object
timings = []

def setup(): 
  size(1000, 700) #Define the size of the canvas
  G =  adjustG(1000,2.5)
  

def draw():
    background(0) #Defines background colour (0=black)
    com(stars) #Showing the stars in the Centre of Mass frame. This makes it simpler to watch, because the stars don't fly off as quickly. Hash this out for lab frame
    m = millis()
    tree.buildTree(stars) #Builds the tree with the stars as elements of the tree.
    bupdateStars(stars,tree) 
    timings.append(millis()-m)
    
def mousePressed():
    avg = 0
    for i in timings:
        avg+=i
    avg= avg/len(timings)
    print(avg)
    

    
    
