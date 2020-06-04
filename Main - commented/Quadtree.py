class Quadtree(object): #Creating the class of objects called Quadtree
    
    def __init__(self, siz=1000): #Function that defines the initial conditions of the tree: the size of the canvas over which it will act.
        self.siz = siz
        
    def buildTree(self,stars): #Defining the function that will build the original tree. It takes the elements, "stars", as its input.
        structure = Node(0,0,self.siz) #Defines the original structure of the tree as being at point 0,0, and having the size as defined above.
        for i in stars:
            structure.insertStar(i) #Iterates over every star in the list of stars, inserting the star as defined in the function below.
        
    
class Node(object): #Creates class of objects called nodes, with properties as follows:
    
    def __init__(self, posx,posy, siz): #Nodes take x and y positions, and size as arguments
        self.pos = PVector(posx,posy) #Position of node on canvas
        self.siz = siz #Size of node, will be updated as the nodes are divided into progressively smaller sub-nodes.
        self.containsStar = False #The default is that there are no stars in any nodes, then we insert the stars into the tree structure according to where they are on the canvas, where this is required.
        self.stars=[] #Creates empty list of stars
        self.com = PVector(0,0) #Centre of mass of the stars is at (0,0) initially. We will update this as stars are added to the node. 
        self.totMass = 0 #Since no star is initially in the node, the initial node mass is 0. This will be updated as stars are added.
        self.external = True #The default is that the node is an external node. External = no children nodes. 
        self.subnodes=[] #This creates an empty list of sub-nodes, into which the eventual children nodes will be inserted, as required.
        
    def isInNode(self,r): #This function defines whether a star is in the node, bases on the star's Pvector r.
        if (r.x < self.pos.x + self.siz) and (r.x > self.pos.x) and (r.y < self.pos.y + self.siz) and (r.y > self.pos.y): 
            return True #If a star is in the node, return true.
        else:
            return False #If star is not in the node, return false.
        
    def updateMass(self,star): #Function updates mass of the node, once a star is added to the node.
        self.com.mult(self.totMass).add(star.pos.copy().mult(star.mass)).div(self.totMass +star.mass ) #Calculates the new CoM of node.
        self.totMass+= star.mass #Updates total mass. += adds star mass to previous total mass.
        
    def insertStar(self,star): #Function that decides whether to insert the star in the node, whether to continue dividing the node.
            if self.isInNode(star.pos):  #First check star is in node.
                if not self.containsStar: #If there are currently no other stars in the node, star is inserted.
                    #print('no stars : ', len(self.stars)) # To test whether function working correctly  
                    self.stars.append(star) #Adds the star to the list of stars within node.
                    self.updateMass(star) #Updates mass of node, since node contains star
                    self.containsStar = True #Updates, so node now contains 1 star
                elif not self.external: #If star has been defined as internal (i.e. already has children/sub-nodes)
                    #print('internal : ', len(self.stars)) # To test whether function working correctly  
                    self.stars.append(star) #Adds the star to the list of stars within node.
                    self.updateMass(star) #Adds the stars mass to the total mass of the node
                    for l in self.subnodes: #Since there are subnodes, we must keep dividing.
                        l.insertStar(star) #Star is inserted into all the subnodes that contain it. Note this is recursive.
                elif self.external: #If node is currently defined as external, i.e. there are no sub-nodes yet. BUT there are other stars in the node (since it was not picked up by if statement), therefore the node must be divided into subnodes. 
                    #print('external : ', len(self.stars)) # To test whether function working correctly  
                    self.stars.append(star) #Adds star to the list of stars in this node.
                    self.updateMass(star) #Updates the mass of the node by adding the mass of this star. 
                    self.external = False #Node is no longer external, since it has subnodes.
                    self.divide() #Divides the node further into 4 subnodes/quadrants.
                    for k in self.stars: # ? 
                        for l in self.subnodes: #Inserts star into one of the subnodes of the node.
                            l.insertStar(k) #Repeats the process for this subnode. Note this is a recursive function.
                        
                self.show() #Shows the nodes, as defined below.
                
        
    def divide(self): #Defines function that divdes node into 4 quadrants
        subsize = self.siz/2 #Side-length of node is halved for each subnode.
        self.subnodes.append(Node(self.pos.x,self.pos.y,subsize)) 
        self.subnodes.append(Node(self.pos.x + subsize,self.pos.y,subsize))
        self.subnodes.append(Node(self.pos.x,self.pos.y + subsize,subsize))
        self.subnodes.append(Node(self.pos.x + subsize,self.pos.y + subsize ,subsize)) #These define the boundaries for the subnodes (equal size)
        
    def show(self): #Shows the nodes. Way to check that nodes are being created correctly.
        stroke(255,0,0) #Colour of lines, (255,0,0) = red using RGB
        line(self.pos.x,self.pos.y,self.pos.x + self.siz ,self.pos.y)
        line(self.pos.x,self.pos.y,self.pos.x,self.pos.y + self.siz)
        line(self.pos.x + self.siz,self.pos.y,self.pos.x + self.siz,self.pos.y + self.siz)
        line(self.pos.x,self.pos.y+self.siz, self.pos.x + self.siz,self.pos.y + self.siz) #These lines define the positions of the lines as along the edges of the nodes/subnodes of the tree.
    
    
    
    
