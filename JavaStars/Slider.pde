class Slider{
    
  float ratio = 2;
   
  PVector pos;
  float wide,leng,range,start,stop;
  int index,listRange;
  boolean isOnDisplay;
  String val;
  int sig;
  
  Slider(float xpos, float start_, float stop_, int i, int n,String val_,int sig_){
  pos = new PVector(xpos,height*i/(n+1));
  wide = width/20;
  leng = wide*ratio;
  range = width *2/3;
  start = start_ ; 
  stop = stop_;
  index = i;
  listRange = n;
  isOnDisplay = false;
  val = val_;
  sig = sig_;
  }

  boolean isInSlider(PVector r){
  if ((r.x  > pos.x ) && (r.x < pos.x +wide) && (r.y > pos.y -leng/2) && (r.y < pos.y +leng/2)){
    return true;  
    }
  else{
    return false;
    }
  }
  
  void moveSliderX(PVector r){
    if (isInSlider(r) && (r.x >(width - range)/2) && (r.x < width - (width-range)/2)){
      pos.x = r.x - wide/2;
    }
  }
  
  float returnValue(){
    float value = map(log(pos.x),log((width-range)/2 - wide/2), log((width - (width - range)/2) - wide/2),log(start), log(stop));
    return exp(value);
  }
  
  void show(){
  float th = height/20;
  noStroke();
  stroke(0);
  strokeWeight(3);
  fill(100,100,250);
 // rect((width-range)/2, index*height/(listRange+1),wide, leng);
  //rect(width-(width-range)/2, index*height/(listRange+1),  wide, leng);
  rect((width-range)/2 - wide/2,index*height/(listRange+1) - th/2,range,th);
  fill(0,0,150);
  stroke(0);
  strokeWeight(5);
  rect(pos.x - wide/2,pos.y - leng /2 ,wide,leng);
  fill(0);
  float v = returnValue();
  if (sig !=0){
  text(val +" = " +nf(v,0,sig) ,(width-range)/2 - wide/4,index*height/(listRange+1)+th/4);
  } else{
  text(val +" = " + int(v) ,(width-range)/2 - wide/4,index*height/(listRange+1)+th/4);
  }
      
  }
}
