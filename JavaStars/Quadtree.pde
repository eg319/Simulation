class Quadtree{
  
  float siz;
  
  Quadtree(float size){
    siz = size;
  }
  
void buildTree(ArrayList<Star> stars){
  Node structure = new Node(0,0,siz);
  for (Star i : stars){
    structure.insertStar(i);
  }
  
  }
}

class Node{

  PVector pos,com;
  boolean containsStar,external;
  float siz,totMass;
  ArrayList<Star> stars;
  ArrayList<Node> subnodes;
  
  Node(float posx,float posy,float size){
    pos = new PVector(posx,posy);
    siz = size;
    containsStar = false;
    stars = new ArrayList<Star>();
    com = new PVector (0,0);
    totMass = 0;
    external = true;
    subnodes = new ArrayList<Node>();
  }
  
  boolean isInNode(PVector r){
    if ((r.x < pos.x + siz) && (r.x > pos.x) && (r.y < pos.y + siz) && (r.y > pos.y)){
      return true;
    } else{
    return false;
    }
  }
  
  void updateMass(Star star){
    com.mult(totMass).add(star.pos.copy().mult(star.mass)).div(totMass + star.mass);
    totMass = totMass + star.mass;
  }

  void insertStar(Star star){
    if (isInNode(star.pos)){
      stars.add(star);
      updateMass(star);
      if (!containsStar){
        containsStar = true;
      } else if (!external){
        for (Node l : subnodes){
          l.insertStar(star);
        }
      } else if (external){
        external = false;
        divide();
        for (Star k : stars){
          for (Node l : subnodes){
            l.insertStar(k);
          }
        }
      }
      show();
    }
  }
  
  void divide(){
    float subsize = siz/2;
    subnodes.add(new Node(pos.x,pos.y,subsize));
    subnodes.add(new Node(pos.x + subsize,pos.y,subsize));
    subnodes.add(new Node(pos.x,pos.y + subsize,subsize));
    subnodes.add(new Node(pos.x + subsize,pos.y + subsize ,subsize));
  }
  
  void show(){
    stroke(255,0,0);
    line(pos.x, pos.y,pos.x + siz ,pos.y);
    line(pos.x,pos.y,pos.x,pos.y + siz);
    line(pos.x + siz,pos.y,pos.x + siz,pos.y + siz);
    line(pos.x,pos.y+siz, pos.x + siz,pos.y + siz);
  
  }
}
