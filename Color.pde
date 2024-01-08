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
        int ir = (int)(Math.min(Math.max(r,0),1) * 255 + 0.1);
        int ig = (int)(Math.min(Math.max(g,0),1) * 255 + 0.1);
        int ib = (int)(Math.min(Math.max(b,0),1) * 255 + 0.1);
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
