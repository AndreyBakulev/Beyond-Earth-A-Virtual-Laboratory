import peasy.*;
PeasyCam cam;
Vector3D[][] globe;
PImage topography;
int w,h;
Sphere sphere;
String photo = Controller.GREYSCALE_IMAGE;
int waterLevel = Controller.WATER_LEVEL;
float altScalar = Controller.ALTITUDE_SCALAR;
int detail = Controller.DETAIL;
int radius = Controller.RADIUS;
int sphereMode = Controller.SPHERE_MODE;
int icoRecursive = Controller.ICO_RECURSIVE;
NormalizedCube[] cubeFaces = new NormalizedCube[6];
SpherifiedCube[] sCubeFaces = new SpherifiedCube[6];
Icosahedron ico = new Icosahedron(icoRecursive,radius);
Vector3D[] direction = {new Vector3D(0,-1,0), new Vector3D(0,1,0),new Vector3D(1,0,0),new Vector3D(-1,0,0),new Vector3D(0,0,1),new Vector3D(0,0,-1)};
String currentShape = "standard";
void setup() {
    size(1280,720,P3D);
    cam = new PeasyCam(this,500);
    topography = loadImage(photo);
    topography.resize(16,9);
    topography.loadPixels();
    sphere = new Sphere(topography.width, topography.height,100,globe);
    sphere.startSphere(currentShape);
    sphere.calculateBiomes();
    ico.createMesh();
    for(int i = 0; i < 6; i++){
        sCubeFaces[i] = new SpherifiedCube(detail,direction[i],radius);
        sCubeFaces[i].constructCube();
        cubeFaces[i] = new NormalizedCube(detail,direction[i],radius);
        cubeFaces[i].constructCube();
    }
    
}
void draw() {
    background(0);
    fill(255);
    lights();
    noStroke();
    switch(sphereMode){
        case 0: 
            sphere.drawSphere();
            currentShape = "standard";
        break;
        case 1:
        for(int i = 0; i < 6; i++){
            cubeFaces[i].drawCube();
        }
        currentShape = "Normalized Cube";
        break;
        case 2:
        for(int i = 0; i < 6; i++){
            sCubeFaces[i].drawCube();
        }
        currentShape = "Spherified Cube";
        break;
        case 3:
        ico.draw();
        currentShape = "Icosahedron";
        break;
    } 
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
            if (keyCode == DOWN && altScalar > 0.01) {
                altScalar -=.01;
                //this is inneficient but idc
                sphere.regenSphere("standard");
            }
        }
        if(key == '1'){
            sphereMode = 0;
        }
        if(key == '2'){
            sphereMode = 1;
        }
        if(key == '3'){
            sphereMode = 2;
        }
        if(key == '4'){
            sphereMode = 3;
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