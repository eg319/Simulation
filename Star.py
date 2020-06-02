class Star(object):

    global G
    G=6.67
    
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
            r=r.normalize().mult(100)
        F_ = self.mass*Star2.mass*G/(r.mag())**2
        F = r.copy().normalize().mult(F_)
        return F
    
    def accel(self,F): # Find the acceleration on the star due to a force
        self.acc = F.div(self.mass)
                         
    def move(self): # Displace star according to new velocity/acceleration
        self.vel.add(self.acc)
        self.pos.add(self.vel)
        
