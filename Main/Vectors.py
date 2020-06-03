class Vectors(object):
    
    def __init__(self,x=0,y=0):
        self.x=x
        self.y=y
        
    def sum(self,v2):
        return Vectors(self.x + v2.x, self.y + v2.y)
    
    def diff(self,v2):
        return Vectors(self.x - v2.x, self.y - v2.y)
    
    def times(self,S):
        return Vectors(self.x * S, self.y * S)
    
    def dott(self,v2):
        return Vectors(self.x *v2.x + self.y * v2.y)
    
    def magn(self):
        return Vectors(self.x**2+self.y**2)**(1/2)
    
    def dirn(self):
        return Vectors(self.x.times(1/self.magn),self.y.times(1/self.magn))
