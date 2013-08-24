
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
            if (
                p.x > 0 && p.x < img.width &&
                p.y > 0 && p.y < img.height
            ) {
                color c = img.get((int)p.x, (int)p.y);
                if (alpha(c) > 1) {
                    return true;
                }
            }
        }
        return false;
    }

    void draw() {
        pushMatrix();

        image(
            img,
            pos.x, pos.y,
            img.width, img.height
        );

        popMatrix();
    }
};
