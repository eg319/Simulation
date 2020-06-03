class Quadtree(object):
    
    def __init__(self, siz=1000):
        self.siz = siz
        
    def buildTree(self,stars):
        structure = Node(0,0,self.siz)
        for i in stars:
            structure.insertStar(i)
        
    
class Node(object):
    
    def __init__(self, posx,posy, siz):
        self.pos = PVector(posx,posy)
        self.siz = siz
        self.containsStar = False
        self.stars=[]
        self.com = PVector(0,0)
        self.totMass = 0
        self.external = True
        self.subnodes=[]
        
    def isInNode(self,r):
        if (r.x < self.pos.x + self.siz) and (r.x > self.pos.x) and (r.y < self.pos.y + self.siz) and (r.y > self.pos.y):
            return True
        else:
            return False
        
    def updateMass(self,star):
        self.com.mult(self.totMass).add(star.pos.copy().mult(star.mass)).div(self.totMass +star.mass )
        self.totMass+= star.mass
        
    def insertStar(self,star):
            if self.isInNode(star.pos): 
                if not self.containsStar:
                    #print('no stars : ', len(self.stars))
                    self.stars.append(star)
                    self.updateMass(star)
                    self.containsStar = True
                elif not self.external:
                    #print('internal : ', len(self.stars))
                    self.stars.append(star)
                    self.updateMass(star)
                    for l in self.subnodes:
                        l.insertStar(star)
                elif self.external:
                    #print('external : ', len(self.stars))
                    self.stars.append(star)
                    self.updateMass(star)
                    self.external = False
                    self.divide() 
                    for k in self.stars:
                        for l in self.subnodes:
                            l.insertStar(k)
                        
                self.show()
                
        
    def divide(self):
        subsize = self.siz/2
        self.subnodes.append(Node(self.pos.x,self.pos.y,subsize))
        self.subnodes.append(Node(self.pos.x + subsize,self.pos.y,subsize))
        self.subnodes.append(Node(self.pos.x,self.pos.y + subsize,subsize))
        self.subnodes.append(Node(self.pos.x + subsize,self.pos.y + subsize ,subsize))
        
    def show(self):
        stroke(255,0,0)
        line(self.pos.x,self.pos.y,self.pos.x + self.siz ,self.pos.y)
        line(self.pos.x,self.pos.y,self.pos.x,self.pos.y + self.siz)
        line(self.pos.x + self.siz,self.pos.y,self.pos.x + self.siz,self.pos.y + self.siz)
        line(self.pos.x,self.pos.y+self.siz, self.pos.x + self.siz,self.pos.y + self.siz)
    
    
    
    
