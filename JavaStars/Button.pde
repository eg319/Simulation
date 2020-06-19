class Button{

  PVector pos;
  float w,h;
  boolean isOnDisplay;
  
  Button(float xpos, float ypos, float w_, float h_ ){
  pos = new PVector (xpos,ypos);
  w = w_;
  h = h_;
  isOnDisplay = true;
  }
 
  void display(){
  fill(0,0,150);
  rect(pos.x,pos.y,w,h);  
  } 
  
  boolean isInButton(PVector r){
  if ((r.x > pos.x)&&(r.x < pos.x + w)&&(r.y > pos.y)&&(r.y < pos.y + h)){
    return true;
    } else {
    return false;
    }
  }
}

class LaunchButton extends Button{

   LaunchButton(float xpos, float ypos, float w_, float h_ ){
   super(xpos,ypos,w_,h_);
   }
   
  void show(){
  super.display();
  fill(200,200,0);
  textSize(32);
  text("Launch Simulation",pos.x+w/10,pos.y+h/2);
  }
}

class SettingsButton extends Button{
    
  SettingsButton(float xpos, float ypos, float w_, float h_ ){
   super(xpos,ypos,w_,h_);
   }

  void show(){
  super.display();
  fill(200,200,0);
  text("Open Settings",pos.x+w/10,pos.y+h/2);
  }
}

class ReturnButton extends Button{
  
  ReturnButton(float xpos, float ypos, float w_, float h_ ){
  super(xpos,ypos,w_,h_);
  super.isOnDisplay = false;
  }
  
  void show(){
  super.display();
  fill(200,200,0);
  text("Return",pos.x+w/10,pos.y + h/2);
  }
}

class ShowGridButton extends Button{
  
  String show;
  
  ShowGridButton(float xpos, float ypos, float w_, float h_ ){
  super(xpos,ypos,w_,h_);
  super.isOnDisplay = false;
  }
  
  void show(){
  super.display();
  fill(200,200,0);
  if (showGrid){
  show = "QuadTree shown";} else {show = "QuadTree hidden";}
  text(show,pos.x+w/10,pos.y + h/2);
  }
}
class Page1Button extends Button{
    
  Page1Button(float xpos, float ypos, float w_, float h_ ){
   super(xpos,ypos,w_,h_);
   super.isOnDisplay = false;
   }

  void show(){
  super.display();
  fill(200,200,0);
  text("◄ Page 1",pos.x+w/10,pos.y+3*h/4);
  }
}
class Page2Button extends Button{
    
  Page2Button(float xpos, float ypos, float w_, float h_ ){
   super(xpos,ypos,w_,h_);
   super.isOnDisplay = false;
   }

  void show(){
  super.display();
  fill(200,200,0);
  text("Page 2 ► ",pos.x+w/10,pos.y+3*h/4);
  }
}
