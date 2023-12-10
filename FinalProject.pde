import peasy.*;
import interfascia.*;
PeasyCam cam;
PVector[][] globe;
PImage topography;
int w,h;
String photo = "marsTopography.jpeg";
Sphere sphere;
int waterLevel = 0;
float altScalar = .1;
  void setup(){
      size(1280,720,P3D);
      cam = new PeasyCam(this,500);
      topography = loadImage(photo);
      topography.resize(640,360);
      topography.loadPixels();
      sphere = new Sphere(0,0,0,topography.width, topography.height,100,globe);
      sphere.generateSphere();
  }
  void draw(){
    background(0);
      fill(255);
      lights();
      noStroke();
      sphere.drawSphere();
      if(keyPressed){
          if(key == CODED){
            //sphere.scaleWater();
              if(keyCode == RIGHT){
                  waterLevel++; 
              }
              if(keyCode == LEFT){
                  waterLevel--; 
              }
              if(keyCode == UP){
                  altScalar+= .01; 
                  //this is inneficient but idc
                  sphere.generateSphere();
              }
              if(keyCode == DOWN){
                  altScalar-= .01;
                  //this is inneficient but idc
                  sphere.generateSphere();
              }
          }
  
      }
  
      textSize(50);
      fill(0,408,612);
      text("Water Level: " + waterLevel,-150,200);
      text("Altitude Scalar: " +altScalar,-150,250);
      //string stuff for fun ig :D
      String planetName = photo.substring(0,photo.indexOf("Topography"));
      //lol all of this long code just to capitalize
      text("Planet: " +planetName.substring(0,1).toUpperCase() + planetName.substring(1),-125,-200);
  
  }




/* 
  PROBLEMS:
    this shit is sloooooooooooow optimize
    scaleWater is not correct
  POSSIBLE OPTIMIZATION:
    make a list of all pixels and remove the ones that are already below water level (same time complexity?)
      the double for loops in drawSphere() that check if waterlevel is higher is O(n^2) i think...
      if i make a 1d array and check it like that (similar to photo.pixels[]), will that be O(n)?
  
  ADDITIONS:
    make the ground colored (map it from greyval seems ez)
    make water 3d
    make the water hold its color as it goes (rainbow like)
    adding compass
    calculating total amt of water on the planet at a certain water level(gallons)
    gulfstreams and grasslands and beaches
    adding something to auto detect range of colors from low to high (so i dont have to use grayscale)
  CLIMATE:
    https://www.jstor.org/stable/24975952?seq=5 go page 5 for graph of temps on mars
*/
