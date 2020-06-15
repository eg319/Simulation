class Slider{
    
  float ratio = 2;
   
  PVector pos;
  float wide,leng,range,start,stop;
  int index,listRange;
  boolean isOnDisplay;
  String val;
  
  Slider(float xpos, float start_, float stop_, int i, int n,String val_){
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
  }

  boolean isInSlider(PVector r){
  if ((r.x  > pos.x) && (r.x < pos.x + wide) && (r.y > pos.y) && (r.y < pos.y +leng)){
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
    float value = map(pos.x,(width-range)/2 - wide/2, (width - (width - range)/2) - wide/2,start,stop);
    return value;
  }
  
  void show(){
  float th = height/20;
  noStroke();
  fill(150);
 // rect((width-range)/2, index*height/(listRange+1),wide, leng);
  //rect(width-(width-range)/2, index*height/(listRange+1),  wide, leng);
  rect((width-range)/2,index*height/(listRange+1) - th,range,th);
  fill(100);
  rect(pos.x - wide/2,pos.y - leng /2 ,wide,leng);
  fill(0);
  text(val +" = " +nf(returnValue(),0,2) ,(width-range)/2,index*height/(listRange+1));
  }
}
