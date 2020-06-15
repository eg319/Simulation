ArrayList<Star> stars; //= generateStars(nStars)
Quadtree tree;
LaunchButton launch;
SettingsButton settings;
ReturnButton returne;
ShowGridButton gridButton;


Slider thetaSlide;
Slider n_Stars;

boolean simulationLaunched = false;
boolean settingsOpen = false;

boolean showGrid = false;

float G ;
float theta;
int nStars;


void setup(){
  orientation(LANDSCAPE);
  fullScreen();
  //size(1000,700);
  G = 2 * pow(10,-2);
  theta = 0.5;
  launch = new LaunchButton(width/2 -width/5 ,height/3 - height/10,width/2.5,height/5);
  settings = new SettingsButton(width/2-width/5 ,2*height/3- height/10, width/2.5,height/5);
  returne = new ReturnButton(width/20,height/20,width/10,height/10);
  gridButton = new ShowGridButton(width*10/20,height/20,width/4,height/10);
  
  thetaSlide = new Slider(width/5.7,0,10,1,2,"Theta");
  n_Stars = new Slider(width/4.8,0,10000,2,2,"Number of stars");
  tree = new Quadtree(width);
}

void draw(){
  background(0);
  if (simulationLaunched){
  launchSimulation();}
  if (settingsOpen){
  openSettings();}


  if (thetaSlide.isOnDisplay){
  thetaSlide.show();
  theta = thetaSlide.returnValue();
  }
  if (n_Stars.isOnDisplay){
  n_Stars.show();
  nStars = int(n_Stars.returnValue());
    
  }

  if (launch.isOnDisplay){
  launch.show();}
  if (settings.isOnDisplay){
  settings.show();}
  if (returne.isOnDisplay){
  returne.show();}
  if (gridButton.isOnDisplay){
  gridButton.show();}
  
 
  
  
  saveFrame("output/galaxy_####.png");
}

void launchSimulation(){
  com(stars);
  tree.buildTree(stars);
  bupdateStars(stars,tree);
}

void openSettings(){
  background(125);
  thetaSlide.isOnDisplay = true;
  n_Stars.isOnDisplay = true;
  gridButton.isOnDisplay = true;
  
}
//void touchStarted(){ //For Android build
void mousePressed(){ // For Java build
  if (launch.isInButton(new PVector(mouseX,mouseY))&& launch.isOnDisplay){
  simulationLaunched = true;
  launch.isOnDisplay = false;
  settings.isOnDisplay = false;
  returne.isOnDisplay = true;
  if (stars == null){
    stars = generateStars(1000);}
  } else if (settings.isInButton(new PVector(mouseX,mouseY))&& settings.isOnDisplay){
  settingsOpen = true;
  launch.isOnDisplay = false;
  settings.isOnDisplay = false;
  returne.isOnDisplay = true;
  } else if (returne.isInButton(new PVector(mouseX,mouseY)) && returne.isOnDisplay){
  settingsOpen = false;
  simulationLaunched = false;
  launch.isOnDisplay = true;
  settings.isOnDisplay = true;
  returne.isOnDisplay = false;
  thetaSlide.isOnDisplay = false;
  if (n_Stars.isOnDisplay){
  stars = generateStars(nStars);}
  n_Stars.isOnDisplay = false;
  gridButton.isOnDisplay = false;
  } else if (gridButton.isInButton(new PVector(mouseX,mouseY)) && gridButton.isOnDisplay){
  showGrid = !showGrid;
  }
  
}


//void touchMoved(){
void mouseDragged(){
   if (thetaSlide.isInSlider(new PVector(mouseX,mouseY))){
     thetaSlide.moveSliderX(new PVector(mouseX,mouseY));
     
   }
  if (n_Stars.isInSlider(new PVector(mouseX,mouseY))){
     n_Stars.moveSliderX(new PVector(mouseX,mouseY));
   }
  
  
}
