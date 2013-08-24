static PImage omgSign;
class EnemyCar extends Obstacle {

    boolean passed = false; // whether the players car has passed this car

    PVector vel;

    float value = 0;


    EnemyCar(String fileName, PVector pos, PVector vel) {
        super(fileName, pos);
        this.vel = vel;
        if (omgSign == null)
            omgSign = loadImage("assets/scaled/warning.png");
    }

    void update() {
        pos.add(vel);

        if (!passed && pos.y >= car.pos.y) {
            passed = true;
            value = abs(pos.x - car.pos.x) * abs(vel.y - car.vel.y);
            score += value;
        }
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