class Star(object): #Created new class of object called stars

    global G #Defines the gravitational constant, can be varied.
    G=6.67*10**(0)
    global theta
    theta = 2
    
    
    def __init__(self, xpos, ypos,velx=0,vely=0, mass=1):  # Object constructor, mass and initial velocity can be varied here.
       self.pos = PVector(xpos,ypos) #Defines intial position of the star
       self.mass = mass #Defines mass of star
       self.acc = PVector(0,0) #Defines initial acceleration of star
       self.vel = PVector(velx,vely) #Defines initial velocity of star, only in x direction now.
       self.siz = 2 #Size of star as shown on the canvas
       self.force = PVector(0,0)
       self.R,self.Gr,self.B = random(200,255), random(200,255),random(0,255)
       
    def show(self): # Display the star on the canvas
        noStroke()
        fill(self.R,self.Gr,self.B) #Defines the colour of the star (255) = white, (255,255,0) = yellow 
        ellipse(self.pos.x,self.pos.y,self.siz,self.siz) # Circular shape of Star
        
    
    def accel(self,F): # Find the acceleration on the star due to a force
        self.acc = F.div(self.mass)
                         
    #def move(self): # Displace star according to new velocity/acceleration / Old version, less accurate, cf. leapfrog for better version
     #   self.vel.add(self.acc)
      #  self.pos.add(self.vel)
      
    def forceFunction(self,Star2): # Calculate the force between 2 stars, using Newton's law
        r1 = self.pos.copy() #Copy must be used so self.pos doesn't change
        r = r1.sub(Star2.pos).mult(-1)
        if r.mag()<10: #This ensure the stars don't collide (which means they don't fly away as much because force due to gravity --> infinity
           r=r.normalize().mult(10)
        F_ = self.mass*Star2.mass*G/(r.mag())**2 #Defines force magnitude
        self.force.add(r.copy().normalize().mult(F_))
    
    def updateForce(self,listOfStars): # Updates the position of a star wrt the force of a list of stars
        for i in listOfStars:
            if i!=self:
                self.forceFunction(i)
                
    
    def modForceFunction(self,node):
        r1 = self.pos.copy() #Copy must be used so self.pos doesn't change
        modcom = node.com.copy()
        modtotMass = node.totMass
        #for i in node.stars:
        #    if i == self:
        #        modtotMass = modtotMass - self.mass
        #        modcom = modcom.mult(node.totMass).sub(self.pos.mult(self.mass)).div(modtotMass)
        r = r1.sub(modcom).mult(-1)
        if r.mag()<10: #This ensure the stars don't collide (which means they don't fly away as much because force due to gravity --> infinity
           r=r.normalize().mult(10)
        F_ = self.mass*modtotMass*G/(r.mag())**2 #Defines force magnitude
        self.force.add(r.copy().normalize().mult(F_))
    
    def bupdateForce(self,node): # When called, the node is tree.structure
        if node.external:
            for i in node.stars:
                if i!=self:
                    self.modForceFunction(node)
        elif (node.siz)/(self.pos.copy().sub(node.com).mag()) < theta:
            self.modForceFunction(node)
        else:
            for i in node.subnodes:
                self.bupdateForce(i)

        
    def leapfrog(self,F): #Leapfrog method to update acceleration and veloctiy in each frame
        self.pos.add(self.vel).add(self.acc.copy().div(2))
        ai=self.acc.copy()
        self.accel(F)
        self.vel.add(ai.add(self.acc).div(2))
        
#Exit class

# Define functions that involve objects of the class        
        
def generateStars(n): # generates n stars in a list
    gal = Galaxy(500,n)
    stars = gal.createStars()
    #stars = []
    #for i in range(n):
    #    stars.append(Star(random(200,600),random(200,500),random(-1,1)))
    return stars

def updateStars(listOfStars):
    for i in listOfStars:
        i.force = PVector(0,0)
    for i in listOfStars:
        i.updateForce(listOfStars)
    for i in listOfStars:
        i.leapfrog(i.force)
        i.show()

def bupdateStars(listOfStars,tree):
    for i in listOfStars:
        i.force = PVector(0,0)
    for i in listOfStars:
        i.bupdateForce(tree.structure)
    for i in listOfStars:
        i.leapfrog(i.force)
        i.show()
        
    

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




class Galaxy:
    
    def __init__(self,radius,nStars,B=1,C=1):
        self.radius = radius
        self.n = nStars
        self.stars = []
        self.B = 0.005
        self.C = 1.3
        
    def densityDistribution(self,x,B,C):
        rho = exp(-B*x**(C))
        return rho
    
    def integrateDensity(self,lim = 0):
        n = int(self.radius)
        integ = 0
        r=0
        for i in range(n):
            integ+= self.densityDistribution(self.radius*i/n,self.B,self.C)*self.radius*i/n
            if lim !=0 and integ > lim:
                r = self.radius*i/n
                print(r)
                break
        if r == 0:
            r = integ
        
        return r
    
    def createStars(self):
        area =  self.integrateDensity()
        print(area)
        for i in range (self.n):
            ran = random(0,area)
            r = self.integrateDensity(ran)
            th = random(0,TAU)
            self.stars.append(Star(r*cos(th),r*sin(th),-sin(th),cos(th),1))
        
        return self.stars
        
        
