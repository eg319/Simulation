class Star {
  
  PVector pos,vel,acc,force;
  float mass,siz;
  //float R = random(0,0),Ge, B = random(255,255);
  float Ge;
  
  Star(float xpos, float ypos, float velx, float vely,float m) {
    pos = new PVector(xpos + 500 ,ypos + 350);
    mass = m;
    vel = new PVector(velx,vely);
    acc = new PVector(0,0);
    siz = staSize; 
    force = new PVector(0,0);
    Ge = 0;
  }
  
  void show(){
  noStroke();
  fill(0,this.Ge,255);
  ellipse(pos.x,pos.y,siz,siz);
  }
  
  void forceFunction(Star Star2){
    PVector r1 = pos.copy();
    PVector r = r1.sub(Star2.pos).mult(-1);
    if (r.mag()<10){
      r=r.normalize().mult(10);
    }
    float F_ = mass*Star2.mass*G/(r.magSq());
    PVector F = r.copy().normalize().mult(F_);
    force.add(F);
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
  
  void updateForce(ArrayList<Star> stars){
    for (Star i : stars){
      if (i != this){
        forceFunction(i);
      }
    }
    //leapfrog(F);
    //show();
    
  }
  
  void modForceFunction(Node node){
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
    if (r.mag()<pow(10,0)* siz){ //This ensure the stars don't collide (which means they don't fly away as much because force due to gravity --> infinity
           //r=r.normalize().mult(10);
           s=0; 
    }
    float F_ = s*mass*modtotMass*G/(r.magSq());
    force.add(r.copy().normalize().mult(F_));
  }
  
  void bupdateForce(Node node){
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
          //Ge = map(force.mag(),0,10,0,255);
      }
    }
  }
}

//Exit class

ArrayList<Star> generateStars(int n){
  ArrayList<Star> stars;
  Galaxy gal = new Galaxy(galRad,n);
  stars = gal.createStars();
  //ArrayList<Star> stars = new ArrayList<Star>();
  //for (int i=0; i<n; i = i+1){
    //stars.add(new Star(random(200,600),random(200,600),random(-0.1,0.1),1));
  //}
  return stars;
}

void updateStars(ArrayList<Star> stars){
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

void bupdateStars(ArrayList<Star> stars, Quadtree tree){
  for (Star i : stars){
    i.force = new PVector(0,0);
  }
  for (Star i : stars){
    i.bupdateForce(tree.structure);
  }
  for (Star i : stars){
    i.leapfrog(i.force);
    i.Ge = map(i.force.mag(),0,0.001,100,255);
    i.show();
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

void extractVelocities(ArrayList<Star> stars){
  for (Star i : stars){
    tab.addRow();
    tab.setFloat(tableRows,"Velocity",i.vel.mag());
    tab.setFloat(tableRows,"Radius",i.pos.copy().sub(new PVector(width/2,height/2)).mag());
    tableRows+=1;
  }
  saveTable(tab,"data/data_####.csv" );

}

float dmDist(float r,float dens, float a ){
float rho = dens/((r/a)*pow((1+r/a),2));
return rho;
}

float integrateDM(float r){
  float l = r*2;
  float integ = 0;
  for (int i = 1; i<l;i+=1){
    integ+= dmDist(r*i/l,charDens,charRad)*r/l;
    }
  integ = integ * 2*PI;
  return integ;
  }

float findMassDM(float r){
  float mass = 4*PI * charDens * pow(charRad,3)*(log((charRad+r)/charRad) - r/(r+charRad));
  return mass;

}

class Galaxy{
  
  float radius,n,A,B;
  ArrayList<Star> stars;
  float[] cumulMass;
  float[] radList;
  
  Galaxy(float rad,float nStars){
    radius = rad;
    n = nStars;
    A= galDistParam;
    B = 1.3;
    stars = new ArrayList<Star>();
    radList = new float[int(nStars)];
    cumulMass = new float[int(rad)];
  }
  
  float densityDistribution(float x,float Al,float Be){
    float rho;
    rho = exp(-Al*pow(x,Be));
    return rho;
  }
  
  float integrateDensity(float lim){
  float l =radius*2,integ =0,r=0;
  for (int i=0; i<l; i = i+1){
    integ+= densityDistribution(radius*i/l,A,B)*radius/l;
    if ((lim != 0) && (integ > lim)){
      r = radius*i/l;
      for (int j= int(r); j< radius ;j = j+1){
        cumulMass[j] = cumulMass[j]+ 1;
        }
      //println(r);
      break;
      }
    }
    if (r ==0){
       r = integ;
     }
   return r;
  }

  
  ArrayList<Star> createStars(){
    float area = integrateDensity(0);
    for (int i = 0; i < radius; i+=1){
      cumulMass[i] = 0;
    }
    //println(area);
    for (int i = 0; i<n;i = i+1){
      float ran = random(0,area);
      float r_ = integrateDensity(ran);
      radList[i] = r_;
    }
    for (int i = 0; i<n; i+=1){
      float r = radList[i];
      float th = random(0,TAU);
      float v = sqrt((cumulMass[int(r)]+findMassDM(r))*G/r);
      //println(cumulMass[int(r)]+integrateDM(r),cumulMass[int(r)]);
      //println(v);
      //v =1;

      stars.add(new Star(r*cos(th),r*sin(th),-v*sin(th),v*cos(th),1));
    }
    //println(cumulMass);
    return stars;
  }
  
}
