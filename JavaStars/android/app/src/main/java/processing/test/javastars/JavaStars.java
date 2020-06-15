package processing.test.javastars;

import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class JavaStars extends PApplet {

ArrayList<Star> stars = generateStars(5000);
Quadtree tree = new Quadtree(1000);
//ArrayList<Float> timings = new ArrayList<Float>();
float m;


public void setup(){
  //fullScreen();
  
}

public void draw(){
  background(0);
  //com(stars);
  tree.buildTree(stars);
  bupdateStars(stars,tree);
  
  //saveFrame("output/galaxy_####.png");
}
class Quadtree{
  
  float siz;
  Node structure;
  
  Quadtree(float size){
    siz = size;
    structure = new Node(0,0,siz);
  }
  
public void buildTree(ArrayList<Star> stars){
  structure = new Node(0,0,siz);
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
  
  public boolean isInNode(PVector r){
    if ((r.x < pos.x + siz) && (r.x > pos.x) && (r.y < pos.y + siz) && (r.y > pos.y)){
      return true;
    } else{
    return false;
    }
  }
  
  public void updateMass(Star star){
    com.mult(totMass).add(star.pos.copy().mult(star.mass)).div(totMass + star.mass);
    totMass = totMass + star.mass;
  }

  public void insertStar(Star star){
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
      //show();
    }
  }
  
  public void divide(){
    float subsize = siz/2;
    subnodes.add(new Node(pos.x,pos.y,subsize));
    subnodes.add(new Node(pos.x + subsize,pos.y,subsize));
    subnodes.add(new Node(pos.x,pos.y + subsize,subsize));
    subnodes.add(new Node(pos.x + subsize,pos.y + subsize ,subsize));
  }
  
  public void show(){
    stroke(255,0,0);
    line(pos.x, pos.y,pos.x + siz ,pos.y);
    line(pos.x,pos.y,pos.x,pos.y + siz);
    line(pos.x + siz,pos.y,pos.x + siz,pos.y + siz);
    line(pos.x,pos.y+siz, pos.x + siz,pos.y + siz);
  
  }
}
float G = 2 * pow(10,-2);

class Star {
  
  
  float theta = 0.5f;
  PVector pos,vel,acc,force;
  float mass,siz;
  float R = random(0,0),Ge = random(100,255), B = random(255,255);
  
  Star(float xpos, float ypos, float velx, float vely,float m) {
    pos = new PVector(xpos + 500 ,ypos + 350);
    mass = m;
    vel = new PVector(velx,vely);
    acc = new PVector(0,0);
    siz = 1; 
    force = new PVector(0,0);
  }
  
  public void show(){
  noStroke();
  fill(R,Ge,B);
  ellipse(pos.x,pos.y,siz,siz);
  }
  
  public void forceFunction(Star Star2){
    PVector r1 = pos.copy();
    PVector r = r1.sub(Star2.pos).mult(-1);
    if (r.mag()<10){
      r=r.normalize().mult(10);
    }
    float F_ = mass*Star2.mass*G/(r.magSq());
    PVector F = r.copy().normalize().mult(F_);
    force.add(F);
  }
  
  public PVector accel(PVector F){
    acc = F.div(mass);
    return acc;
  }
  
  public void leapfrog(PVector F){
    pos.add(vel).add(acc.copy().div(2));
    PVector ai = acc.copy();
    accel(F);
    vel.add(ai.add(acc).div(2));
  }
  
  public void updateForce(ArrayList<Star> stars){
    for (Star i : stars){
      if (i != this){
        forceFunction(i);
      }
    }
    //leapfrog(F);
    //show();
    
  }
  
  public void modForceFunction(Node node){
    PVector r1 = pos.copy(); //Copy must be used so self.pos doesn't change
    PVector modcom = node.com.copy();
    float modtotMass = node.totMass;
    float s =1;
    for (Star i : node.stars){
      if (i == this){
         modtotMass = modtotMass - mass;
         modcom = modcom.mult(node.totMass).sub(pos.mult(mass)).div(modtotMass);
        }
      }
    PVector r = r1.sub(modcom).mult(-1);
    if (r.mag()<siz){ //This ensure the stars don't collide (which means they don't fly away as much because force due to gravity --> infinity
           //r=r.normalize().mult(10);
           s=0; 
    }
    float F_ = s*mass*modtotMass*G/(r.magSq());
    force.add(r.copy().normalize().mult(F_));
  }
  
  public void bupdateForce(Node node){
  if (node.external){
    for (Star i : node.stars){
      if (i != this){
        modForceFunction(node);
        }
      }
    } else if (node.siz/(pos.copy().sub(node.com).mag()) < theta){
         modForceFunction(node);
    } else{
        for (Node i : node.subnodes){
          bupdateForce(i);
      }
    }
  }
}

//Exit class

public ArrayList<Star> generateStars(int n){
  ArrayList<Star> stars;
  Galaxy gal = new Galaxy(500,n);
  stars = gal.createStars();
  //ArrayList<Star> stars = new ArrayList<Star>();
  //for (int i=0; i<n; i = i+1){
    //stars.add(new Star(random(200,600),random(200,600),random(-0.1,0.1),1));
  //}
  return stars;
}

public void updateStars(ArrayList<Star> stars){
  for (Star i : stars){
    i.force = new PVector(0,0);
  }
  for (Star i : stars){
    i.updateForce(stars);
  }
  for (Star i : stars){
    i.leapfrog(i.force);
    i.show();
  }
}

public void bupdateStars(ArrayList<Star> stars, Quadtree tree){
  for (Star i : stars){
    i.force = new PVector(0,0);
  }
  for (Star i : stars){
    i.bupdateForce(tree.structure);
  }
  for (Star i : stars){
    i.leapfrog(i.force);
    i.show();
  }
}

public void com(ArrayList<Star> stars){
  PVector r = new PVector(0,0);
  for (Star i : stars){
    r.add(i.pos.copy().mult(i.mass));
  }
  r.div(totalMass(stars));
  for (Star i : stars){
    i.pos.sub(r).add(new PVector(width/2,height/2));
  }
}

public float totalMass(ArrayList<Star> stars){
  float tm = 0.0f;
  for (Star i : stars){
    tm = tm + i.mass;
    }
  return tm;
  
}

class Galaxy{
  
  float radius,n,A,B;
  ArrayList<Star> stars;
  
  Galaxy(float rad,float nStars){
    radius = rad;
    n = nStars;
    A=0.005f;
    B = 1.3f;
    stars = new ArrayList<Star>();
  }
  
  public float densityDistribution(float x,float Al,float Be){
    float rho;
    rho = exp(-Al*pow(x,Be));
    return rho;
  }
  
  public float integrateDensity(float lim){
  float l =radius*2,integ =0,r=0;
  for (int i=0; i<l; i = i+1){
    integ+= densityDistribution(radius*i/l,A,B)*radius/l;
    if ((lim != 0) && (integ > lim)){
      r = radius*i/l;
      //println(r);
      break;
      }
    }
    if (r ==0){
       r = integ;
     }
   return r;
  }
  
  public ArrayList<Star> createStars(){
    float area = integrateDensity(0);
    print(area);
    for (int i = 0; i<n;i = i+1){
      float ran = random(0,area);
      float r = integrateDensity(ran);
      float th = random(0,TAU);
      float v = 1/sqrt(r);
      v =1;

      stars.add(new Star(r*cos(th),r*sin(th),-v*sin(th),v*cos(th),1));
    }
    return stars;
  }
  
}
  public void settings() {  size(1000,700); }
}
