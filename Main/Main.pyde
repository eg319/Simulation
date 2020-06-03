from Star import *
from Quadtree import *

stars = generateStars(20)
tree = Quadtree()

def setup(): 
  size(1000, 700)

def draw():
    background(0)
    updateStars(stars)
    com(stars)
    tree.buildTree(stars)

    
