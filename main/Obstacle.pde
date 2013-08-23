
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
            PVector f = pt.sub(pos.sub(img.width, img.height, 0));
        }
        return false;
    }

    void draw() {
        pushMatrix();
        translate(pos.x, pos.y);

        image(
            img,
            pos.x, pos.y,
            img.width, img.height
        );

        popMatrix();
    }
};
