from Star import *


stars = []
for i in range(20):
    stars.append(Star(random(200,600),random(200,500),random(-1,1)))

def setup(): 
  size(1000, 700)


def draw():
    background(0)
    for i in stars:
        i.show()
    for i in stars:
        F = PVector(0,0)
        for j in stars:
            if i!=j:
                F.add(i.force(j))
        i.accel(F)
        i.move()
    