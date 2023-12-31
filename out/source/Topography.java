/* autogenerated by Processing revision 1293 on 2024-01-09 */
import processing.core.*;
import processing.data.*;
import processing.event.*;
import processing.opengl.*;

import peasy.*;

import java.util.HashMap;
import java.util.ArrayList;
import java.io.File;
import java.io.BufferedReader;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.IOException;

public class Topography extends PApplet {

/* 
PROBLEMS:

FIGURE OUT HOW TO DO STATIC CLASSES SO U CAN MAKE BIOMES WORK
POSSIBLE OPTIMIZATION:
make a list of all pixels and remove the ones that are already below water level (same time complexity?)
the double for loops in drawSphere() that check if waterlevel is higher is O(n^2) i think...
for biomes, figure out how to make the if statements check linear graphs, not just a single number (bc the biomes arent perfectly rectangular)

ADDITIONS:
maybe add "initialGlobe" array to GenerateSphere so we can call it on waterLevelDown
make the ground colored (map it from greyval seems ez)
adding compass
calculating total amt of water on the planet at a certain water level(gallons)

ecology stuff:
gulfstreams and grasslands and beaches
adding something to auto detect range of colors from low to high (so i dont have to use grayscale)
CLIMATE:
https://www.jstor.org/stable/24975952?seq=5 go page 5 for graph of temps on mars
*/
public static class Color {
    private double r,g,b;
   
    //just making colors to make life easier
    public static Color Tundra(){
        return new Color(148,169,174);
    }
    public static Color Grassland(){
        return new Color(147,127,44);
    }
    public static Color Woodland(){
        return new Color(180,125,1);
    }
    public static Color Boreal_Forest(){
        return new Color(91,144,81);
    }
    public static Color Seasonal_Forest(){
        return new Color(40,138,161);
    }
    public static Color Temperate_Forest(){
        return new Color(3,83,109);
    }
    public static Color Subtropical_Desert(){
        return new Color(201,114,52);
    }
    public static Color Savanna(){
        return new Color(152,167,34);
    }
    public static Color Tropical_Rainforest(){
        return new Color(1,82,44);
    }
    public Color(double r, double g, double b){
        this.r = r;
        this.g = g;
        this.b = b;
    }
    //returning the r,g,b of the color
    public double getR(){
        return r;
    }
    public double getG(){
        return g;
    }
    public double getB(){
        return b;
    }
    //adding two color's r g b values
    public Color add(Color C){
        return new Color(this.r + C.getR(), this.g + C.getG(), this.b+C.getB());
    }
    //multiply the r g b values of this color by a scalar
    public Color scale(double scalar){
        return new Color(this.r*scalar,this.g*scalar,this.b*scalar);
    }
    //whatever this does
    public int toARGB(){
        int ir = (int)(Math.min(Math.max(r,0),1) * 255 + 0.1f);
        int ig = (int)(Math.min(Math.max(g,0),1) * 255 + 0.1f);
        int ib = (int)(Math.min(Math.max(b,0),1) * 255 + 0.1f);
        return (ir << 16) | (ig << 8) | (ib << 0);
        //bit shifting 
    }
    //multiplies the color by the shading color c
    public Color shade(Color c){
        return new Color(this.getR()*c.getR(), this.getG()*c.getG(), this.getB()*c.getB());
    }
    //tints the color by the tinting color c
    public Color tint(Color c){
        double newR = r + (1 - r)*c.getR();
        double newG = g + (1 - g)*c.getG();
        double newB = b + (1 - b)*c.getB();
        return new Color(newR, newG, newB);

    }

}

PeasyCam cam;
Vector3D[][] globe;
PImage topography;
int w,h;
String photo = "marsTopography.jpeg";
Sphere sphere;
int waterLevel = 0;
float altScalar =.1f;
public void setup() {
    /* size commented out by preprocessor */;
    cam = new PeasyCam(this,500);
    topography = loadImage(photo);
    topography.resize(320,180);
    topography.loadPixels();
    sphere = new Sphere(0,0,0,topography.width, topography.height,100,globe);
    sphere.generateSphere("standard");
    sphere.calculateBiomes();
    
}
public void draw() {
    background(0);
    fill(255);
    lights();
    noStroke();
    sphere.drawSphere();
    if (keyPressed) {
        if (key == CODED) {
            if (keyCode == RIGHT) {
                waterLevel++; 
                sphere.scaleWaterUp();
            }
            if (keyCode == LEFT) {
                waterLevel--; 
                sphere.scaleWaterDown();
            }
            if (keyCode == UP) {
                altScalar +=.01f; 
                //this is inneficient but idc
                sphere.generateSphere("standard");
            }
            if (keyCode == DOWN) {
                altScalar -=.01f;
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
class Sphere {
    float x, y, z, r;
    int w, h;
    Vector3D[][] globe;
    Color[][] greyScale;
    int groundLevel = 30;
    double altitude;
    float[][] tempMap;
    float[][] rainMap;
    Sphere(float x, float y, float z, int w, int h, float r, Vector3D[][] globe) {
        this.x = x;
        this.y = y;
        this.z = z;
        this.w = w;
        this.h = h;
        this.r = r;
        this.globe = globe;
    }
    public void generateSphere(String sphereType) {
        //drawing simple sphere
        if(sphereType.equals("standard")){
            greyScale = new Color[h][w];
            globe = new Vector3D[h][w];
            tempMap = new float[h][w];
            rainMap = new float[h][w];
            for (int i = 0; i < h; i++) {
                // mapping the latitude as i percent of the way to total (i/total) and putting
                // it into pi (if i is 25 then it would b 25 percent(25/100) of pi (.25/pi)
                float lat = map(i, 0, h, 0, PI);
                for (int j = 0; j < w; j++) {
                    // mapping the longitude as j percent of the way to total (j/total) and putting
                    // it into 2pi (j is 25 then it would b 25 percent of pi (.25/2pi)
                    float lon = map(j, 0, w, 0, 2 * PI);
                    // literally just polar coords
                    float x = r * sin(lat) * sin(lon);
                    float y = -r * cos(lat);
                    float z = r * sin(lat) * cos(lon);
                    // storing the coords into array of vectors
                    globe[i][j] = new Vector3D(x, y, z);
                    int greyVal = Integer.parseInt(binary(topography.pixels[(i * w) + j] % 256, 8));
                    //saves it into an array ONCE
                    greyScale[i][j] = new Color(this.binConvert(greyVal),this.binConvert(greyVal),this.binConvert(greyVal));
                    altitude =  greyScale[i][j].getR() - groundLevel;
                    globe[i][j] = globe[i][j].scale((r + (altitude * altScalar)) / r);
                    tempMap[i][j] = random(-10,35);
                    rainMap[i][j] = random(0,450);
                }
            }
        }        
    }
    public void drawSphere() {
        for (int i = 0; i < h; i++) {
            // quad prob easier but tri could b as well
            beginShape(QUAD_STRIP);
            for (int j = 0; j < w; j++) {
                if (greyScale[i][j].getR() <= waterLevel) {
                    fill(0, 0, 255);
                } else {
                    fill((float)greyScale[i][j].getR(), (float)greyScale[i][j].getG(), (float)greyScale[i][j].getB());
                }
                // this is altitude stuff
                Vector3D v1 = globe[i][j];
                // top left point
                vertex((float)v1.x,(float) v1.y,(float) v1.z);
                //this is checking for south pole (i=h) to 0
                if (i != h - 1) {
                    Vector3D v2 = globe[i + 1][j];
                    vertex((float)v2.x,(float) v2.y, (float)v2.z);
                } else {
                    vertex((float)0,(float)1 * r,(float)0);
                }
                // bottom left point
                
            }
            //this is checking for last strip from (i=h) to 0
            Vector3D v3 = globe[i][0];
            vertex((float)v3.x,(float)v3.y,(float)v3.z);
            if (i != h - 1) {
                Vector3D v4 = globe[i + 1][0];
                vertex((float)v4.x,(float)v4.y,(float)v4.z);
            } else {
                vertex((float)0,(float)1 * r,(float)0);
            }
            endShape();
        }
    }
    public void scaleWaterUp() {
        for (int i = 0; i < h; i++) {
            for (int j = 0; j < w; j++){
                if (greyScale[i][j].getR() <= waterLevel) {
                    globe[i][j] =globe[i][j].normalize().scale((r + ((waterLevel-groundLevel) * altScalar)));
                }
            }
        }
    }
    public void scaleWaterDown() {
        for (int i = 0; i < h; i++) {
            for (int j = 0; j < w; j++){
                if (waterLevel <= greyScale[i][j].getR()) {
                   globe[i][j] = globe[i][j].normalize().scale((r + ((greyScale[i][j].getR()-groundLevel) * altScalar)));
                } else {
                    globe[i][j] = globe[i][j].normalize().scale((r + ((waterLevel-groundLevel) * altScalar)));
                }
            }
        }
    }
    public void calculateBiomes(){
        for(int i = 0; i < greyScale.length;i++){
            for(int j = 0; j < greyScale[i].length;j++){
                float temp = tempMap[i][j];
                float rain = rainMap[i][j];
                //bunch of if statements checking what biome it is based off x(temp) and y(rainfall)
                //is it better to do nested for loops here?
                if(temp < 0){
                    if(rain<100){
                       greyScale[i][j] = Color.Tundra();
                    }
                }
                if(0 < temp && temp < 7){
                    if(rain < 20){
                        greyScale[i][j] = Color.Grassland();
                    }
                    if(20 < rain && rain < 30){
                        greyScale[i][j] = Color.Woodland();
                    }
                    if(30 < rain){
                        greyScale[i][j] = Color.Boreal_Forest();
                    }
                }
                if(7<temp && temp <21){
                    if(rain < 25){
                        greyScale[i][j] = Color.Grassland();
                    }
                    if(25<rain && rain <100){
                         greyScale[i][j] = Color.Woodland();
                    }
                    if(100<rain && rain<200){
                        greyScale[i][j] = Color.Seasonal_Forest();
                    }
                    if(200<rain){
                        greyScale[i][j] = Color.Temperate_Forest();
                    }
                }
                if(21<temp){
                    if(rain<60){
                        greyScale[i][j] = Color.Subtropical_Desert();
                    }
                    if(60<rain && rain<250){
                        greyScale[i][j] = Color.Savanna();
                    }
                    if(250<rain){
                        greyScale[i][j] = Color.Tropical_Rainforest();
                    }
                }
            }
        }
    }
    public int binConvert(int binary) {
        int decimal = 0;
        int n = 0;
        while(true) {
            if (binary == 0) {
                break;
            } else {
                int temp = binary % 10;
                decimal += temp * Math.pow(2, n);
                binary /= 10;
                n++;
            }
        }
        return decimal;
    }
}
class Vector2D{
  public double x;
  public double y;

  public Vector2D(double x, double y){
    this.x = x;
    this.y = y;
    
  }
  public double getX(){
    return x;
  }
  public double getY(){
    return y;
  }
  public void applyForce(Vector2D force){
    x = x + force.getX();
    y = y + force.getY();
  }
  public Vector2D scale(double scalar){
    return new Vector2D(x*scalar,y*scalar);
  }
  public Vector2D add(Vector2D v){
    return new Vector2D(x+v.getX(),y+v.getY());
  }
  public Vector2D subtract(Vector2D v){
    return new Vector2D(x-v.getX(),y-v.getY());
  }
  public double dot(Vector2D v){
    return (x*v.getX() + y*v.getY());
  }
  public double length(){
    return Math.sqrt(this.dot(this));
  }
  public Vector2D normalize(){
    return this.scale(1/this.length());
  }
   public String toString(){
    return "(" + x + ", " + y + ")";
  }
}
class Vector3D{
  public double x;
  public double y;
  public double z;
  public Vector3D(double x, double y, double z){
    this.x = x;
    this.y = y;
    this.z = z;
  }
  public double getx(){
    return x;
  }
  public double gety(){
    return y;
  }
  public double getz(){
    return z;
  }
  public void applyForce(Vector3D force){
    x = x + force.getx();
    y = y + force.gety();
    z = z + force.getz();
  }
  public Vector3D scale(double scalar){
    return new Vector3D(x*scalar,y*scalar,z*scalar);
  }
  public Vector3D divide(double scalar){
    return new Vector3D(x/scalar,y/scalar,z/scalar);
  }
  public Vector3D add(Vector3D v){
    return new Vector3D(x+v.getx(),y+v.gety(),z+v.getz());
  }
  public Vector3D subtract(Vector3D v){
    return new Vector3D(x-v.getx(),y-v.gety(),z-v.getz());
  }
  public double dot(Vector3D v){
    return (x*v.getx() + y*v.gety() + z*v.getz());
  }
  public double length(){
    return Math.sqrt(this.dot(this));
  }
  public Vector3D normalize(){
    return this.scale(1/this.length());
  }
  public Vector3D cross(Vector3D v){
    return new Vector3D((this.y*v.z) - (this.z*v.y),(this.z*v.x)- (this.x*v.z), (this.x*v.y)-(this.y*v.x));
  }

  public String toString(){
    return "(" + x + ", " + y + ", " + z + ")";
  }
  public  Vector3D Up(){ return new Vector3D(0,1,0);}
  public  Vector3D Down(){ return new Vector3D(0,-1,0);}
  public  Vector3D Left(){ return new Vector3D(-1,0,0);}
  public  Vector3D Right(){ return new Vector3D(1,0,0);}
  public  Vector3D Forward(){ return new Vector3D(0,0,-1);}
  public  Vector3D Backward(){ return new Vector3D(0,0,1);}
}


  public void settings() { size(1280, 720, P3D); }

  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Topography" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
