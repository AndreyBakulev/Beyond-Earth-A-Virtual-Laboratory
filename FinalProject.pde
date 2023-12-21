import peasy.*;
PeasyCam cam;
PVector[][] globe;
PImage topography;
int w,h;
String photo = "marsTopography.jpeg";
Sphere sphere;
int waterLevel = 0;
float altScalar =.1;
void setup() {
    size(1280,720,P3D);
    cam = new PeasyCam(this,500);
    topography = loadImage(photo);
    topography.resize(640,360);
    topography.loadPixels();
    sphere = new Sphere(0,0,0,topography.width, topography.height,100,globe);
    sphere.generateSphere("standard");
}
void draw() {
    background(0);
    fill(255);
    lights();
    noStroke();
    sphere.drawSphere();
    if (keyPressed) {
        if (key == CODED) {
            //sphere.scaleWater();
            if (keyCode == RIGHT) {
                waterLevel++; 
            }
            if (keyCode == LEFT) {
                waterLevel--; 
            }
            if (keyCode == UP) {
                altScalar +=.01; 
                //this is inneficient but idc
                sphere.generateSphere("standard");
            }
            if (keyCode == DOWN) {
                altScalar -=.01;
                //this is inneficient but idc
                sphere.generateSphere("standard");
            }
        }
        
}
    
    textSize(50);
    fill(0,408,612);
    text("Water Level: " + waterLevel, - 150,200);
    text("Altitude Scalar: " + altScalar, - 150,250);
    //string stuff for fun ig :D
    String planetName = photo.substring(0,photo.indexOf("Topography"));
    //lol all of this long code just to capitalize
    text("Planet: " + planetName.substring(0,1).toUpperCase() + planetName.substring(1), - 125, - 200);
    
}




