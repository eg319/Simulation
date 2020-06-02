from Star import *

stars = generateStars(20)

def setup(): 
  size(1000, 700)

def draw():
    background(0)
    updateStars(stars)
