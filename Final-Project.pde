import peasy.*;
PeasyCam cam;
Vector3D[][] globe;
PImage originalTopography;
int w,h;
Sphere sphere;
enum STATE{
    GAME,
    MENU,
    FEATURES,
    INSTRUCTIONS
};
STATE state;
double aspectRatio;
int photoDetail = Controller.PHOTO_DETAIL;
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
    state  = STATE.MENU;
    cam = new PeasyCam(this,500);
    originalTopography = loadImage(photo);
    originalTopography.loadPixels();
    aspectRatio =  1 / ((double)(originalTopography.width)/(double)(originalTopography.height));
    sphere = new Sphere(radius,globe);
    sphere.startSphere(currentShape);
    //sphere.getBiomes();
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
    if(state == STATE.MENU){
        cam.beginHUD();
        fill(0,408,612);
        textSize(60);
        textMode(CENTER);
        text("Beyond Earth:",width/2,115);
        text("A Virtual Laboratory",width/2,175);
        textSize(20);
        text("By Andrey Bakulev", width/2,210);
        textSize(40);
        fill(255);
        text("START", width/2,325);
        text("TUTORIAL", width/2,425);
        text("FEATURES", width/2,525);
        text("QUIT", width/2,625);
        rectMode(CENTER);
        if(mouseX > width/2 -55 && mouseX < width/2 + 55 && mouseY > 300 && mouseY < 325){
            if(mousePressed){
                state = STATE.GAME;
            }
        }
        if(mouseX > width/2 - 85 && mouseX < width/2 + 85 && mouseY > 400 && mouseY <  425){
            if(mousePressed){
                state = STATE.INSTRUCTIONS;
            }
        }
        if(mouseX > width/2 - 85 && mouseX < width/2 + 85 && mouseY > 500 && mouseY <  525){
            if(mousePressed){
                state = STATE.FEATURES;
            }
        }
        if(mouseX > width/2 - 45 && mouseX < width/2 + 45 && mouseY > 600 && mouseY < 625){
            if(mousePressed){
                exit();
            }
        }
        cam.endHUD();
    }
    if(state == STATE.INSTRUCTIONS){
        cam.beginHUD();
        fill(0,408,612);
        textSize(60);
        textMode(CENTER);
        text("How To Use:",width/2,115);
        textSize(30);
        fill(255);
        text("To scale planet altitude, use UP and DOWN arrow keys",width/2,175);
        text("To change water level of planet, use LEFT and RIGHT arrow keys",width/2,250);
        text("To change detail level, use Q and E",width/2,325);
        text("Use keys 1-4 to see different ways to render a sphere (WIP)",width/2,400);
        textSize(40);
        text("BACK", width/2,660);
        rectMode(CENTER);
        if(mouseX > 610 && mouseX < 695 && mouseY > 630 && mouseY < 660){
            if(mousePressed){
                state = STATE.MENU;
            }
        }
        cam.endHUD();
    }
    if(state == STATE.FEATURES){
        cam.beginHUD();
        fill(0,408,612);
        textSize(60);
        textMode(CENTER);
        text("Features:",width/2,115);
        textSize(30);
        fill(255);
        text("Planetary Altitude Scaling",width/2,175);
        text("Accurate Water level measuring",width/2,250);
        text("Detail level of planet",width/2,325);
        text("Different methods of creating a sphere (WIP)",width/2,400);
        textSize(40);
        text("BACK", width/2,660);
        rectMode(CENTER);
        if(mouseX > 610 && mouseX < 695 && mouseY > 630 && mouseY < 660){
            if(mousePressed){
                state = STATE.MENU;
            }
        }
        cam.endHUD();
    }
    if(state == STATE.GAME){
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
            text("Detail: " + ((cubeFaces[1].resolution)-1) + " (Q/E)", 0,275);
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
            text("Detail: " + ((sCubeFaces[1].resolution)-1)+ " (Q/E)", 0,275);
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
                    if(sphereMode == 0 && waterLevel < 300){  waterLevel++;}
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
                    if(sphereMode == 0 && waterLevel > 0){
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
            if(sphereMode == 0 && sphere.w < originalTopography.width-1){
                sphere.w = (int) ((1.02*sphere.w) + 1);
                sphere.h = (int) (sphere.w * aspectRatio);
                sphere.startSphere("standard");
                // sphere.getBiomes();
                // sphere.calculateBiomes();
            }
            if(sphereMode == 1 && cubeFaces[1].resolution < 31){
                for(int i = 0; i < cubeFaces.length;i++){
                    cubeFaces[i].resolution++;
                    cubeFaces[i].constructCube();
                }
            }
            if(sphereMode == 2 && sCubeFaces[1].resolution < 31){
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
            if(sphereMode == 0 && sphere.w > 5){
                sphere.w =(int) (.98*sphere.w);
                sphere.h = (int) (sphere.w * aspectRatio);
                sphere.startSphere("standard");
                // sphere.getBiomes();
                // sphere.calculateBiomes();
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
}