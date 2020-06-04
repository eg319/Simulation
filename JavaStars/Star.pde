class Star {
  
  float G = 6.67 * pow(10,0);
  PVector pos,vel,acc;
  float mass,siz;
  
  
  Star(float xpos, float ypos, float velx,float m) {
    pos = new PVector(xpos,ypos);
    mass = m;
    vel = new PVector(velx,0);
    acc = new PVector(0,0);
    siz = 4; 
  }
  
  void show(){
  noStroke();
  fill(255,255,0);
  ellipse(pos.x,pos.y,siz,siz);
  }
  
  PVector force(Star Star2){
    PVector r1 = pos.copy();
    PVector r = r1.sub(Star2.pos).mult(-1);
    if (r.mag()<10){
      r=r.normalize().mult(10);
    }
    float F_ = mass*Star2.mass*G/(r.magSq());
    PVector F = r.copy().normalize().mult(F_);
    return F;
  }
  
  PVector accel(PVector F){
    acc = F.div(mass);
    return acc;
  }
  
  void leapfrog(PVector F){
    pos.add(vel).add(acc.copy().div(2));
    PVector ai = acc.copy();
    accel(F);
    vel.add(ai.add(acc).div(2));
  }
  
  void update(ArrayList<Star> stars){
    PVector F = new PVector(0,0);
    for (Star i : stars){
      if (i != this){
        F.add(force(i));
      }
    }
    leapfrog(F);
    show();
    
  }
}

ArrayList<Star> generateStars(int n){
  ArrayList<Star> stars = new ArrayList<Star>();
  for (int i=0; i<n; i = i+1){
    stars.add(new Star(random(200,600),random(200,600),random(-0.1,0.1),1));
  }
  return stars;
}

void updateStars(ArrayList<Star> stars){
  for (Star i : stars){
    i.update(stars);
  }
}

void com(ArrayList<Star> stars){
  PVector r = new PVector(0,0);
  for (Star i : stars){
    r.add(i.pos.copy().mult(i.mass));
  }
  r.div(totalMass(stars));
  for (Star i : stars){
    i.pos.sub(r).add(new PVector(width/2,height/2));
  }
}

float totalMass(ArrayList<Star> stars){
  float tm = 0.0;
  for (Star i : stars){
    tm = tm + i.mass;
    }
  return tm;
  
}
