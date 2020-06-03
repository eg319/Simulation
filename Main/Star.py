class Star(object):

    global G
    G=6.67*10**(1)
    
    def __init__(self, xpos, ypos,velx=0, mass=1):  # Object constructor
       self.pos = PVector(xpos,ypos)
       self.mass = mass
       self.acc = PVector(0,0)
       self.vel = PVector(velx,0)
       self.siz = 5
       
    def show(self): # Display the star on the canvas
        fill(255)
        ellipse(self.pos.x,self.pos.y,self.siz,self.siz)
        
    def force(self,Star2): # Calculate the force between 2 stars
        r1 = self.pos.copy()
        r = r1.sub(Star2.pos).mult(-1)
        if r.mag()<10:
            r=r.normalize().mult(10)
        F_ = self.mass*Star2.mass*G/(r.mag())**2
        F = r.copy().normalize().mult(F_)
        return F
    
    def accel(self,F): # Find the acceleration on the star due to a force
        self.acc = F.div(self.mass)
                         
    def move(self): # Displace star according to new velocity/acceleration
        self.vel.add(self.acc)
        self.pos.add(self.vel)
    
    def update(self,listOfStars): # Updates the position of a star wrt the force of a list of stars
        F = PVector(0,0)
        for i in listOfStars:
            if i!=self:
                F.add(self.force(i))
        self.accel(F)
        self.move()
        self.show()
        
        
#Exit class

# Define functions that involve objects of the class        
        
def generateStars(n): # generates n stars in a list
    stars = []
    for i in range(n):
        stars.append(Star(random(200,600),random(200,500),random(-1,1)))
    return stars

def updateStars(listOfStars):
    for i in listOfStars:
        i.update(listOfStars)

def com(listOfStars): # transfers to COM frame
    r=PVector(0,0)
    for i in listOfStars:
        r.add(i.pos.copy().mult(i.mass))
    r.div(totalMass(listOfStars))
    for i in listOfStars:
        i.pos.sub(r).add(PVector(width/2,height/2))
        
def totalMass(listOfStars):
    tm = 0
    for i in listOfStars:
        tm+=i.mass
    return tm

        
