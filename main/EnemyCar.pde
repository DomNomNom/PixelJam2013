static PImage omgSign;
class EnemyCar extends Obstacle {


    PVector vel;

    EnemyCar(String fileName, PVector pos, PVector vel) {
        super(fileName, pos);
        this.vel = vel;
        if (omgSign == null)
            omgSign = loadImage("assets/scaled/warning.png");
    }

    void update() {
        pos.add(vel);
    }

    void draw() {
        pushMatrix();


        if (pos.y < cam.top) {
            translate(pos.x, car.pos.y + 70);
            image(omgSign, 0, 0);
        }
        else {
            translate(pos.x, pos.y);
            if (vel.y > 0)
                rotate(PI);

            image(img,0, 0);
        }
        popMatrix();
    }
};


static List<String> carImages = new ArrayList<String>(); static{
    carImages.add("assets/scaled/sedan_black.png");
    carImages.add("assets/scaled/sedan_blue.png");
    carImages.add("assets/scaled/sedan_green.png");
    carImages.add("assets/scaled/sedan_red.png");
    carImages.add("assets/scaled/sedan_white.png");
    carImages.add("assets/scaled/van.png");
    // carImages.add("assets/scaled/train.png");
}
String randomCar() {
    return carImages.get(int(random(carImages.size())));
}