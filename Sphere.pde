class Sphere {
    float x, y, z, r;
    int w, h;
    Vector3D[][] globe;
    Color[][] greyScale;
    double[][] altitude;
    float[][] tempMap;
    float[][] rainMap;
    Sphere(float r, Vector3D[][] globe) {
        this.w = topography.width;
        this.h = topography.height;
        this.r = r;
        this.globe = globe;
    }
    void startSphere(String sphereType) {
        if(sphereType.toLowerCase().equals("standard")){
            greyScale = new Color[h][w];
            globe = new Vector3D[h][w];
            tempMap = new float[h][w];
            rainMap = new float[h][w];
            altitude = new double[h][w];
            x = 0;
            y = 0;
            z = 0;
            for (int i = 0; i < h; i++) {
                // mapping the latitude as i percent of the way to total (i/total) and putting
                // it into pi (if i is 25 then it would b 25 percent(25/100) of pi (.25/pi)
                float lat = map(i, 0, h, 0, PI);
                for (int j = 0; j < w; j++) {
                    // mapping the longitude as j percent of the way to total (j/total) and putting
                    // it into 2pi (j is 25 then it would b 25 percent of pi (.25/2pi)
                    float lon = map(j, 0, w, 0, 2 * PI);
                    // literally just polar coords
                    x = r * sin(lat) * sin(lon);
                    y = -r * cos(lat);
                    z = r * sin(lat) * cos(lon);
                    // storing the coords into array of vectors
                    globe[i][j] = new Vector3D(x, y, z);
                    int greyVal = Integer.parseInt(binary(topography.pixels[(i * w) + j] % 256, 8));
                    //saves it into an array ONCE
                    greyScale[i][j] = new Color(this.binConvert(greyVal),this.binConvert(greyVal),this.binConvert(greyVal));
                    altitude[i][j] =  greyScale[i][j].getR();
                    globe[i][j] = globe[i][j].scale((r + (altitude[i][j] * altScalar)) / r);
                    tempMap[i][j] = random(-10,35);
                    rainMap[i][j] = random(0,450);
                }
            }
        }        
    }
    void drawSphere() {
        for(int i = 0; i < h; i++){
            for (int j = 0; j < w; j++) {
                if (altitude[i][j] <= waterLevel) {
                    globe[i][j] =globe[i][j].normalize().scale((r + ((waterLevel) * altScalar)));
                }
            }
        }
        for (int i = 0; i < h; i++) {
            beginShape(QUAD);
            for (int j = 0; j < w; j++) {
                // this is altitude stuff
                if (altitude[i][j] <= waterLevel) {
                    fill((float)Color.Water().getR(), (float)Color.Water().getG(), (float)Color.Water().getB());
                } else {
                    fill((float)greyScale[i][j].getR(), (float)greyScale[i][j].getG(), (float)greyScale[i][j].getB());
                }
                if(i != h - 1 && j != w-1){ 
                    Vector3D v1 = globe[i][j];
                    Vector3D v2 = globe[i][j+1];
                    Vector3D v3 = globe[i+1][j]; 
                    Vector3D v4 = globe[i+1][j+1];
                    vertex((float)v1.x,(float) v1.y,(float) v1.z);
                    vertex((float)v2.x,(float) v2.y, (float)v2.z);
                    vertex((float)v4.x,(float) v4.y, (float)v4.z);
                    vertex((float)v3.x,(float) v3.y, (float)v3.z);
                }
                if(i == h-1 && j != w-1){
                    Vector3D v5 = globe[i][j];
                    Vector3D v6 = globe[i][j+1];
                    vertex((float)v5.x,(float) v5.y,(float) v5.z);
                    vertex((float)v6.x,(float) v6.y,(float) v6.z);
                    vertex((float)0,(float)(1 * ((r + (altitude[i][0] * altScalar)))),(float)0);
                    vertex((float)0,(float)(1 * ((r + (altitude[i][0] * altScalar)))),(float)0);
                }
            }
            //this is checking for last strip from (i=h) to 0
            Vector3D v7 = globe[i][w-1];
            Vector3D v8 = globe[i][0];
            vertex((float)v7.x,(float)v7.y,(float)v7.z);
            vertex((float)v8.x,(float)v8.y,(float)v8.z);
            if (i != h - 1) {
                Vector3D v9 = globe[i + 1][w-1];
                Vector3D v10 = globe[i + 1][0];
                vertex((float)v10.x,(float)v10.y,(float)v10.z);
                vertex((float)v9.x,(float)v9.y,(float)v9.z);
            } else {
                vertex((float)0,(float)(1 * ((r + (altitude[i][0] * altScalar)))),(float)0);
                vertex((float)0,(float)(1 * ((r + (altitude[i][0] * altScalar)))),(float)0);
            }
            endShape();
        }
    }
    void regenSphere(String sphereType) {
        //drawing simple spheres
        if(sphereType.equals("standard")){
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
                    globe[i][j] = globe[i][j].scale((r + (altitude[i][j] * altScalar)) / r);
                    tempMap[i][j] = random(-10,35);
                    rainMap[i][j] = random(0,450);
                }
            }
        }        
    }
    void scaleWaterDown() {
        for (int i = 0; i < h; i++) {
            for (int j = 0; j < w; j++){
                if (waterLevel <= altitude[i][j]) {
                   globe[i][j] = globe[i][j].normalize().scale((r + ((altitude[i][j]) * altScalar)));
                } else {
                    globe[i][j] = globe[i][j].normalize().scale((r + ((waterLevel) * altScalar)));
                }
            }
        }
    }
    void calculateBiomes(){
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
    int binConvert(int binary) {
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
/* NOTES:
altitude is now an array which holds the values of each pixels altitude (called once and is unchanged)
*/