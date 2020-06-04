class Star(object): #Created new class of object called stars

    global G #Defines the gravitational constant, can be varied.
    G=6.67*10**(0)
    
    def __init__(self, xpos, ypos,velx=0, mass=1):  # Object constructor, mass and initial velocity can be varied here.
       self.pos = PVector(xpos,ypos) #Defines intial position of the star
       self.mass = mass #Defines mass of star
       self.acc = PVector(0,0) #Defines initial acceleration of star
       self.vel = PVector(velx,0) #Defines initial velocity of star, only in x direction now.
       self.siz = 10 #Size of star as shown on the canvas
       
    def show(self): # Display the star on the canvas
        noStroke()
        fill(255,255,0) #Defines the colour of the star (255) = white, (255,255,0) = yellow 
        ellipse(self.pos.x,self.pos.y,self.siz,self.siz) # Circular shape of Star
        
    def force(self,Star2): # Calculate the force between 2 stars, using Newton's law
        r1 = self.pos.copy() #Copy must be used so self.pos doesn't change
        r = r1.sub(Star2.pos).mult(-1)
        if r.mag()<10: #This ensure the stars don't collide (which means they don't fly away as much because force due to gravity --> infinity
           r=r.normalize().mult(10)
        F_ = self.mass*Star2.mass*G/(r.mag())**2 #Defines force
        F = r.copy().normalize().mult(F_)
        return F
    
    def accel(self,F): # Find the acceleration on the star due to a force
        self.acc = F.div(self.mass)
                         
    #def move(self): # Displace star according to new velocity/acceleration / Old version, less accurate, cf. leapfrog for better version
     #   self.vel.add(self.acc)
      #  self.pos.add(self.vel)
    
    def update(self,listOfStars): # Updates the position of a star wrt the force of a list of stars
        F = PVector(0,0)
        for i in listOfStars:
            if i!=self:
                F.add(self.force(i))
        self.leapfrog(F)
        #self.accel(F)
        #self.move()   # Old versions of position update
        self.show()
        
    def leapfrog(self,F): #Leapfrog method to update acceleration and veloctiy in each frame
        self.pos.add(self.vel).add(self.acc.copy().div(2))
        ai=self.acc.copy()
        self.accel(F)
        self.vel.add(ai.add(self.acc).div(2))
        
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

        
