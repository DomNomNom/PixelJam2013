
class Obstacle {

    PVector pos;

    PImage img;

    Obstacle(String fileName, PVector pos) {
        this.pos = pos;
        img = loadImage(fileName);
    }


    void update() { }

    boolean isColliding() {
        return false;
    }
}