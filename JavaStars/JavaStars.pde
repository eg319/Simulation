
ArrayList stars = generateStars(3000);
Quadtree tree = new Quadtree(1000);
  

void setup(){
  size(1000,700);
}

void draw(){
  background(0);
  updateStars(stars);
  com(stars);
  tree.buildTree(stars);
    
}
