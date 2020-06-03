from Star import *

stars = generateStars(2)

def setup(): 
  size(1000, 700)

def draw():
    background(0)
    updateStars(stars)
    com(stars)

    
