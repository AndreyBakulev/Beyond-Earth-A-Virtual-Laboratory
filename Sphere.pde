class Sphere {
    float x, y, z, r;
    int w, h;
    PVector[][] globe;
    int[][] greyScale;
    int groundLevel = 30;
    int altitude;
    
    Sphere(float x, float y, float z, int w, int h, float r, PVector[][] globe) {
        this.x = x;
        this.y = y;
        this.z = z;
        this.w = w;
        this.h = h;
        this.r = r;
        this.globe = globe;
    }
    void generateSphere() {
        greyScale = new int[h][w];
        globe = new PVector[h][w];
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
                globe[i][j] = new PVector(x, y, z);
                int greyVal = Integer.parseInt(binary(topography.pixels[(i * w) + j] % 256, 8));
                //saves it into an array ONCE
                greyScale[i][j] = this.binConvert(greyVal);
                altitude = greyScale[i][j] - groundLevel;
                globe[i][j].mult((r + (altitude * altScalar)) / r);
            }
        }
        
    }
    void drawSphere() {
        for (int i = 0; i < h; i++) {
            // quad prob easier but tri could b as well
            beginShape(QUAD_STRIP);
            for (int j = 0; j < w; j++) {
                if (greyScale[i][j] <= waterLevel) {
                    fill(waterLevel, waterLevel / 2, waterLevel * 2);
                } else {
                    fill(greyScale[i][j], greyScale[i][j], greyScale[i][j]);
                }
                // this is altitude stuff
                
                PVector v1 = globe[i][j];
                // top left point
                vertex(v1.x, v1.y, v1.z);
                //this is checking for south pole (i=h) to 0
                if (i != h - 1) {
                    PVector v2 = globe[i + 1][j];
                    vertex(v2.x, v2.y, v2.z);
                } else {
                    vertex(0,1 * r,0);
                }
                // bottom left point
                
            }
            //this is checking for last strip from (i=h) to 0
            PVector v3 = globe[i][0];
            vertex(v3.x,v3.y,v3.z);
            if (i != h - 1) {
                PVector v4 = globe[i + 1][0];
                vertex(v4.x,v4.y,v4.z);
            } else {
                vertex(0,1 * r,0);
            }
            
            endShape();
        }
        
    }
    void scaleWater() {
        //this is def not correct or efficient
        //multiplying itself and not getting reset thats why its bigger than the ground 'above' it
        for (int i = 0; i < h; i++) {
            for (int j = 0; j < w; j++) {
                if (greyScale[i][j] <= waterLevel) {
                    globe[i][j].mult((r + (waterLevel * .00)) / r);
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
