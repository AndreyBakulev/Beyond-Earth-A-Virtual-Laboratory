import peasy.*;
PeasyCam cam;
Vector3D[][] globe;
PImage topography;
int w,h;
String photo = "marsTopography.jpeg";
Sphere sphere;
int waterLevel = 0;
float altScalar =.04;
void setup() {
    size(1280,720,P3D);
    cam = new PeasyCam(this,500);
    topography = loadImage(photo);
    topography.resize(320,180);
    topography.loadPixels();
    sphere = new Sphere(topography.width, topography.height,100,globe);
    sphere.startSphere("standard");
    sphere.calculateBiomes();
    
}
void draw() {
    background(0);
    fill(255);
    lights();
    noStroke();
    sphere.drawSphere();
    if (keyPressed) {
        if (key == CODED) {
            if (keyCode == RIGHT) {
                waterLevel++; 
            }
            if (keyCode == LEFT) {
                waterLevel--; 
                sphere.scaleWaterDown();
            }
            if (keyCode == UP) {
                altScalar +=.01; 
                //this is inneficient but idc
                sphere.regenSphere("standard");
            }
            if (keyCode == DOWN) {
                altScalar -=.01;
                //this is inneficient but idc
                sphere.regenSphere("standard");
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