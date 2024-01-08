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
    void generateSphere(String sphereType) {
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
    void drawSphere() {
        for (int i = 0; i < h; i++) {
            // quad prob easier but tri could b as well
            beginShape(QUAD_STRIP);
            for (int j = 0; j < w; j++) {
                if (greyScale[i][j].getR() <= waterLevel) {
                    fill(waterLevel, waterLevel / 2, waterLevel * 2);
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
    void scaleWaterUp() {
        for (int i = 0; i < h; i++) {
            for (int j = 0; j < w; j++){
                if (greyScale[i][j].getR() <= waterLevel) {
                    globe[i][j].normalize().scale((r + ((waterLevel-groundLevel) * altScalar)));
                }
            }
        }
    }
    void scaleWaterDown() {
        for (int i = 0; i < h; i++) {
            for (int j = 0; j < w; j++){
                if (waterLevel <= greyScale[i][j].getR()) {
                    globe[i][j].normalize().scale((r + ((greyScale[i][j].getR()-groundLevel) * altScalar)));
                } else {
                    globe[i][j].normalize().scale((r + ((waterLevel-groundLevel) * altScalar)));
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
                        //tundra
                       greyScale[i][j] = new Color(148,169,174);
                    }
                }
                if(0 < temp && temp < 7){
                    if(rain < 20){
                        //grassland
                        greyScale[i][j] = new Color(147,127,44);
                    }
                    if(20 < rain && rain < 30){
                        //woodland
                        greyScale[i][j] = new Color(180,125,1);
                    }
                    if(30 < rain){
                        //boreal forest
                        greyScale[i][j] = new Color(91,144,81);
                    }
                }
                if(7<temp && temp <21){
                    if(rain < 25){
                        //grassland
                        greyScale[i][j] = new Color(147,127,44);
                    }
                    if(25<rain && rain <100){
                        //woodland
                         greyScale[i][j] = new Color(180,125,1);
                    }
                    if(100<rain && rain<200){
                        //seasonal forest
                        greyScale[i][j] = new Color(40,138,161);
                    }
                    if(200<rain){
                        //temperate forest
                        greyScale[i][j] = new Color(3,83,109);
                    }
                }
                if(21<temp){
                    if(rain<60){
                        //subtropical desert
                        greyScale[i][j] = new Color(201,114,52);
                    }
                    if(60<rain && rain<250){
                        //savanna
                        greyScale[i][j] = new Color(152,167,34);
                    }
                    if(250<rain){
                        //tropical rainforest
                        greyScale[i][j] = new Color(1,82,44);
                    }
                }
                //maps the temp to max and min colors
                // greyScale[i][j].r = (int) (map(tempMap[i][j],-10,35,0,255));
                // greyScale[i][j].g = (int) (map(tempMap[i][j],-10,35,0,255));
                // greyScale[i][j].b = (int) (map(tempMap[i][j],-10,35,0,255));
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
