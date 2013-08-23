
class Obstacle {

    PVector pos;

    PImage img;

    Obstacle(String fileName, PVector pos) {
        this.pos = pos;
        img = loadImage(fileName);
    }


    void update() { }

    boolean isColliding() {
        for(PVector pt : car.collisionPts){
            PVector s = new PVector(img.width/2, img.height/2);
            PVector b = pos.get();
            b.sub(s);
            PVector p = pt.get();
            p.sub(b);
            
            rect(p.x, p.y, 4, 4);
        }
        return false;
    }
}
