import peasy.*;
PeasyCam cam;
Vector3D[][] globe;
PImage topography;
int w,h;
Sphere sphere;
int photoDetail = Controller.PHOTO_DETAIL;
String photo = Controller.GREYSCALE_IMAGE;
int waterLevel = Controller.WATER_LEVEL;
float altScalar = Controller.ALTITUDE_SCALAR;
int detail = Controller.DETAIL;
int radius = Controller.RADIUS;
int sphereMode = Controller.SPHERE_MODE;
int icoRecursive = Controller.ICO_RECURSIVE;
double aspectRatio;
NormalizedCube[] cubeFaces = new NormalizedCube[6];
SpherifiedCube[] sCubeFaces = new SpherifiedCube[6];
Icosahedron ico = new Icosahedron(icoRecursive,radius);
Vector3D[] direction = {new Vector3D(0,-1,0), new Vector3D(0,1,0),new Vector3D(1,0,0),new Vector3D(-1,0,0),new Vector3D(0,0,1),new Vector3D(0,0,-1)};
String currentShape = "standard";
void setup() {
    size(1280,720,P3D);
    cam = new PeasyCam(this,500);
    topography = loadImage(photo);
    aspectRatio =  1 / ((double)(topography.width)/(double)(topography.height));
    topography.resize(photoDetail,(int) (photoDetail*aspectRatio));
    topography.loadPixels();
    sphere = new Sphere(radius,globe);
    sphere.startSphere(currentShape);
    //sphere.calculateBiomes();
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
    textAlign(CENTER);
    switch(sphereMode){
        case 0: 
            sphere.drawSphere();
            currentShape = "Standard";
            textSize(25);
            fill(0,408,612);
            text("Water Level: " + waterLevel+ " (LEFT/RIGHT)", 0,175);
            text("Altitude Scalar: " + altScalar + " (UP/DOWN)", 0,225);
            text("Detail: " + sphere.w + " x " + sphere.h + " (Q/E)", 0,275);
            fill(255);
        break;
        case 1:
            for(int i = 0; i < 6; i++){
                cubeFaces[i].drawCube();
            }
            currentShape = "Normalized Cube";
            textSize(25);
            fill(0,408,612);
            text("Water Level: " + waterLevel+ " (LEFT/RIGHT)", 0,175);
            text("Altitude Scalar: " + altScalar + " (UP/DOWN)", 0,225);
            text("Detail: " + cubeFaces[1].resolution + " (Q/E)", 0,275);
            fill(255);
        break;
        case 2:
            for(int i = 0; i < 6; i++){
                sCubeFaces[i].drawCube();
            }
            currentShape = "Spherified Cube";
            textSize(25);
            fill(0,408,612);
            text("Water Level: " + waterLevel+ " (LEFT/RIGHT)", 0,175);
            text("Altitude Scalar: " + altScalar + " (UP/DOWN)", 0,225);
            text("Detail: " + sCubeFaces[1].resolution + " (Q/E)", 0,275);
            fill(255);
        break;
        case 3:
            ico.draw();
            currentShape = "Icosahedron";
            textSize(25);
            fill(0,408,612);
            text("Water Level: " + waterLevel+ " (LEFT/RIGHT)", 0,175);
            text("Altitude Scalar: " + altScalar + " (UP/DOWN)", 0,225);
            text("Detail: " + ico.recursionAmt + " (Q/E)", 0,275);
            fill(255);
        break;
    } 
    if (keyPressed) {
        if (key == CODED) {
                if (keyCode == RIGHT) {
                    if(sphereMode == 0){
                        waterLevel++; 
                    }
                    if(sphereMode == 1){
                        for(int i = 0; i < cubeFaces.length;i++){
                            //prob water level here
                        }
                    }
                    if(sphereMode == 2 ){
                        for(int i = 0; i < sCubeFaces.length;i++){
                           //water level
                        }
                    }
                    if(sphereMode == 3){
                        
                    }
                }
                if (keyCode == LEFT) {
                    if(sphereMode == 0){
                        waterLevel--; 
                        sphere.scaleWaterDown();
                    }
                    if(sphereMode == 1){
                        for(int i = 0; i < cubeFaces.length;i++){
                            
                        }
                    }
                    if(sphereMode == 2){
                        for(int i = 0; i < sCubeFaces.length;i++){
                            
                        }
                    }
                    if(sphereMode == 3){

                    }
                }
                if (keyCode == UP) {
                    if(sphereMode == 0){
                        altScalar +=.01; 
                        //this is inneficient but idc
                        sphere.regenSphere("standard");
                    }
                    if(sphereMode == 1){
                        for(int i = 0; i < cubeFaces.length;i++){
                            //altitude
                        }
                    }
                    if(sphereMode == 2){
                        for(int i = 0; i < sCubeFaces.length;i++){
                           //altitude
                        }
                    }
                    if(sphereMode == 3 ){
                        //altitude
                    }
                }
                if (keyCode == DOWN && altScalar > 0.01) {
                    if(sphereMode == 0 && altScalar > 0.01){
                        altScalar -=.01;
                        //this is inneficient but idc
                        sphere.regenSphere("standard");
                    }
                    if(sphereMode == 1){
                        for(int i = 0; i < cubeFaces.length;i++){
                            //altitude
                        }
                    }
                    if(sphereMode == 2){
                        for(int i = 0; i < sCubeFaces.length;i++){
                            //altitude
                        }
                    }
                    if(sphereMode == 3){
                        //alt
                    }
                }
        }
        if(key == 'e'){
            if(sphereMode == 0){
                sphere.w++;
                sphere.h = (int) (sphere.w * aspectRatio);
                topography.resize(sphere.w,sphere.h);
                sphere.regenSphere("standard");
            }
            if(sphereMode == 1 && cubeFaces[1].resolution < 30){
                for(int i = 0; i < cubeFaces.length;i++){
                    cubeFaces[i].resolution++;
                    cubeFaces[i].constructCube();
                }
            }
            if(sphereMode == 2 && sCubeFaces[1].resolution < 30){
                for(int i = 0; i < sCubeFaces.length;i++){
                    sCubeFaces[i].resolution++;
                    sCubeFaces[i].constructCube();
                }
            }
            if(sphereMode == 3 && ico.recursionAmt < 5){
                ico.recursionAmt++;
                ico.createMesh();
            }
        }
        if(key == 'q'){
            if(sphereMode == 0 && altScalar > 0.01){
                sphere.w--;
                sphere.h = (int) (sphere.w * aspectRatio);
                sphere.regenSphere("standard");
            }
            if(sphereMode == 1 && cubeFaces[1].resolution > 2){
                for(int i = 0; i < cubeFaces.length;i++){
                    cubeFaces[i].resolution--;
                    cubeFaces[i].constructCube();
                }
            }
            if(sphereMode == 2 && sCubeFaces[1].resolution > 2){
                for(int i = 0; i < sCubeFaces.length;i++){
                    sCubeFaces[i].resolution--;
                    sCubeFaces[i].constructCube();
                }
            }
            if(sphereMode == 3 && ico.recursionAmt > 0){
                ico.recursionAmt--;
                ico.createMesh();
            }
        }
        //this is for switching
        for(int i = 1; i < 5;i++){
            if(key == (char)(i+'0')){
                sphereMode = i-1;
            }
        }
    }   
    //string stuff for fun ig :D
    String planetName = photo.substring(0,photo.indexOf("Topography"));
    //lol all of this long code just to capitalize
    fill(0,408,612);
    text("Planet: " + planetName.substring(0,1).toUpperCase() + planetName.substring(1),0, - 225);
    text("Sphere Type: " + currentShape,0, -150);
}