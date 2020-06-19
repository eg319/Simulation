ArrayList<Star> stars; //= generateStars(nStars)
Quadtree tree;
LaunchButton launch;
SettingsButton settings;
ReturnButton returne;
ShowGridButton gridButton;
Page1Button page1;
Page2Button page2;

Slider thetaSlide;
Slider n_Stars;
Slider starSize;
Slider galRadius;
Slider spScaleSlider;
Slider tiScaleSlider;
Slider galDistParamSlider;
Slider charRadSlider;
Slider charDensSlider;


Table tab = new Table();
int tableRows = 0;


boolean simulationLaunched = false;
boolean settingsOpen = false;

boolean showGrid = false;

float G ;
float theta;
float staSize;
float galRad;
float charRad,charDens;
float galDistParam;
float spScale,tiScale;

int nStars;


void setup(){
  orientation(LANDSCAPE);
  //fullScreen();
  size(1000,700);
  //G = 2 * pow(10,-2);
  //theta = 0.5;
  
  //charRad = 10;
  //charDens = pow(10,-2);
  
  launch = new LaunchButton(width/2 -width/5 ,height/3 - height/10,width/2.5,height/5);
  settings = new SettingsButton(width/2-width/5 ,2*height/3- height/10, width/2.5,height/5);
  returne = new ReturnButton(width/20,height/40,width/10,height/10);
  gridButton = new ShowGridButton(width*10/20,height/40,width/4,height/10);
  page1 = new Page1Button(width*10/20,height*36/40,width/4,height/15);
  page2 = new Page2Button(width*10/20,height*36/40,width/4,height/15);
  
  thetaSlide = new Slider(width/2.6,0.01,10,1,4,"Theta",2);
  n_Stars = new Slider(width*5/9,1,50000,2,4,"Number of stars",0);
  starSize = new Slider(width/4.5,0.5,100,3,4,"Size of stars",2);
  galDistParamSlider = new Slider(width*3.25/11,0.00001,0.1,4,4,"Galaxy distribution parameter",5);
  
  spScaleSlider = new Slider(width*7.25/11,0.01,10000,1,5,"1 px in LY",2);
  tiScaleSlider = new Slider(width*0.95/2,0.0025,50,2,5,"1 frame in MYears",4);
  charRadSlider = new Slider(width*7/11,0.1,20,3,5,"Characteristic DM radius",1);
  charDensSlider = new Slider(width*7/11,0.001,100,4,5,"Characteristic DM density",3);
  galRadius = new Slider(width*7/11,10,width/2,5,5,"Galaxy radius",0);
  
  
  tab.addColumn("Radius", Table.FLOAT);
  tab.addColumn("Velocity",Table.FLOAT);
  
  tree = new Quadtree(3*width);
  println(tree.structure.pos,tree.structure.siz);
}

void draw(){
  background(0);
  if (simulationLaunched){
  launchSimulation();}
  if (settingsOpen){
  openSettings();}


  if (thetaSlide.isOnDisplay){
  thetaSlide.show();
  }
  if (n_Stars.isOnDisplay){
  n_Stars.show();
  }
  if (starSize.isOnDisplay){
  starSize.show();
  }
  if (galRadius.isOnDisplay){
  galRadius.show();
  }
  if (spScaleSlider.isOnDisplay){
  spScaleSlider.show();
  }
  if (tiScaleSlider.isOnDisplay){
  tiScaleSlider.show();
  }
  if (charDensSlider.isOnDisplay){
  charDensSlider.show();
  }
  if (charRadSlider.isOnDisplay){
  charRadSlider.show();
  }
  if (galDistParamSlider.isOnDisplay){
  galDistParamSlider.show();
  }
  
  
  if (launch.isOnDisplay){
  launch.show();}
  if (settings.isOnDisplay){
  settings.show();}
  if (returne.isOnDisplay){
  returne.show();}
  if (gridButton.isOnDisplay){
  gridButton.show();}
  
 
  
  
  //saveFrame("output/galaxy_####.png");
}

void launchSimulation(){
  com(stars);
  tree.buildTree(stars);
  bupdateStars(stars,tree);
 // extractVelocities(stars);
}

void openSettings(){
  background(0,0,50);
  if (page2.isOnDisplay){
    page2.show();
    openPage1();
  }
  
  if (page1.isOnDisplay){
    page1.show();
    openPage2();
  }
}
void openPage1(){
  thetaSlide.isOnDisplay = true;
  n_Stars.isOnDisplay = true;
  gridButton.isOnDisplay = true;
  starSize.isOnDisplay = true;
  galDistParamSlider.isOnDisplay = true;
  
  galRadius.isOnDisplay = false;
  spScaleSlider.isOnDisplay = false;
  tiScaleSlider.isOnDisplay = false;
  charDensSlider.isOnDisplay = false;
  charRadSlider.isOnDisplay = false;
  
}

void openPage2(){
  thetaSlide.isOnDisplay = false;
  n_Stars.isOnDisplay = false;
  gridButton.isOnDisplay = false;
  starSize.isOnDisplay = false;
  galDistParamSlider.isOnDisplay = false;
  
  galRadius.isOnDisplay = true;
  spScaleSlider.isOnDisplay = true;
  tiScaleSlider.isOnDisplay = true;
  charDensSlider.isOnDisplay = true;
  charRadSlider.isOnDisplay = true;
}

void adjustG(float spaceScale, float timeScale){
  G = 6.67 * pow(spaceScale*9.461,-3)*pow(timeScale*3.6524*2.4*3.6,2)*1.8/nStars *pow(10,9);
  println(G);
}

//void touchStarted(){ //For Android build
void mousePressed(){ // For Java build
  if (launch.isInButton(new PVector(mouseX,mouseY))&& launch.isOnDisplay){
  simulationLaunched = true;
  launch.isOnDisplay = false;
  settings.isOnDisplay = false;
  returne.isOnDisplay = true;
  
  //spScale = spScaleSlider.returnValue();
  //tiScale = tiScaleSlider.returnValue();
  adjustG(spScale,tiScale); // Old reference : 1000,2.5
  //galDistParam = galDistParamSlider.returnValue();
  //charDens = charDensSlider.returnValue();
  //charRad = charRadSlider.returnValue();
  //galRad = int(galRadius.returnValue());
  //staSize = starSize.returnValue();
  //nStars = int(n_Stars.returnValue());
  //theta = thetaSlide.returnValue();
  stars = generateStars(nStars);
  
  
  } else if (settings.isInButton(new PVector(mouseX,mouseY))&& settings.isOnDisplay){
  settingsOpen = true;
  launch.isOnDisplay = false;
  settings.isOnDisplay = false;
  returne.isOnDisplay = true;
  page2.isOnDisplay = true;
  } else if (returne.isInButton(new PVector(mouseX,mouseY)) && returne.isOnDisplay){
  settingsOpen = false;
  simulationLaunched = false;
  launch.isOnDisplay = true;
  settings.isOnDisplay = true;
  returne.isOnDisplay = false;
  thetaSlide.isOnDisplay = false;
  n_Stars.isOnDisplay = false;
  gridButton.isOnDisplay = false;
  starSize.isOnDisplay = false;
  galRadius.isOnDisplay = false;
  spScaleSlider.isOnDisplay = false;
  tiScaleSlider.isOnDisplay = false;
  charDensSlider.isOnDisplay = false;
  charRadSlider.isOnDisplay = false;
  galDistParamSlider.isOnDisplay = false;
  
  spScale = spScaleSlider.returnValue();
  tiScale = tiScaleSlider.returnValue();
  galDistParam = galDistParamSlider.returnValue();
  charDens = charDensSlider.returnValue();
  charRad = charRadSlider.returnValue();
  galRad = int(galRadius.returnValue());
  staSize = starSize.returnValue();
  nStars = int(n_Stars.returnValue());
  theta = thetaSlide.returnValue();
  
  } else if (gridButton.isInButton(new PVector(mouseX,mouseY)) && gridButton.isOnDisplay){
  showGrid = !showGrid;
  } else if (page1.isInButton(new PVector(mouseX,mouseY)) && page1.isOnDisplay){
  page1.isOnDisplay = false;
  page2.isOnDisplay = true;
  } else if (page2.isInButton(new PVector(mouseX,mouseY)) && page2.isOnDisplay){
  page1.isOnDisplay = true;
  page2.isOnDisplay = false;
  }
  
}


//void touchMoved(){
void mouseDragged(){
   
  if (thetaSlide.isInSlider(new PVector(mouseX,mouseY)) && thetaSlide.isOnDisplay){
     thetaSlide.moveSliderX(new PVector(mouseX,mouseY));
     
   }
  if (n_Stars.isInSlider(new PVector(mouseX,mouseY)) && n_Stars.isOnDisplay){
     n_Stars.moveSliderX(new PVector(mouseX,mouseY));
   }
  
  if (starSize.isInSlider(new PVector(mouseX,mouseY))&& starSize.isOnDisplay){
     starSize.moveSliderX(new PVector(mouseX,mouseY));
   }
   
   if (galRadius.isInSlider(new PVector(mouseX,mouseY))&& galRadius.isOnDisplay){
     galRadius.moveSliderX(new PVector(mouseX,mouseY));
   }
   
   if (spScaleSlider.isInSlider(new PVector(mouseX,mouseY))&& spScaleSlider.isOnDisplay){
     spScaleSlider.moveSliderX(new PVector(mouseX,mouseY));
   }
   
    if (tiScaleSlider.isInSlider(new PVector(mouseX,mouseY)) && tiScaleSlider.isOnDisplay){
     tiScaleSlider.moveSliderX(new PVector(mouseX,mouseY));
   }
   
    if (charDensSlider.isInSlider(new PVector(mouseX,mouseY))&& charDensSlider.isOnDisplay){
     charDensSlider.moveSliderX(new PVector(mouseX,mouseY));
   }
   
   if (charRadSlider.isInSlider(new PVector(mouseX,mouseY))&& charRadSlider.isOnDisplay){
     charRadSlider.moveSliderX(new PVector(mouseX,mouseY));
   }
   
   if (galDistParamSlider.isInSlider(new PVector(mouseX,mouseY))&& galDistParamSlider.isOnDisplay){
     galDistParamSlider.moveSliderX(new PVector(mouseX,mouseY));
   }
}
