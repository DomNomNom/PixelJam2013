float dlerp(float low, float high, float t) {
  return lerp(low, high, constrain(t, 0 , 1));
}


static PImage omgSign;

class EnemyCar extends Obstacle {

    boolean passed = false; // whether the players car has passed this car

    PVector vel;

    // scoring system
    float value = 0; // score gained
    float value_YOLO = 1000;
    float value_nothing = 0;
    float space_YOLO = 9;
    float space_nothing = 120;


    EnemyCar(String fileName, PVector pos, PVector vel) {
        super(fileName, pos);
        this.vel = vel;
        if (omgSign == null)
            omgSign = loadImage("assets/scaled/warning.png");
    }


    void update() {
        pos.add(vel);

        // have we just passed the car?
        if (!passed && pos.y >= car.pos.y && !car.dead) {
            passed = true;

            float space = abs(pos.x - car.pos.x) - img.width*0.5 - car.hitbox.x; // space between the cars
            int distScore = int(dlerp(
                value_YOLO,
                value_nothing,
                (space-space_YOLO) / (space_nothing - space_YOLO)
            ));

            if (distScore >= 1000) {
                car.YOLO();
            }

            // calculte the score
            value = int(
                distScore
                // * abs(vel.y - car.vel.y)
            );

            // score modifiers
            if (drunk > 0) value *= (drunk+1);
            if (vel.y > 0) value *= 1.5;
            // value = (float)(Math.floor(value));

            scoreNotify.notify(pos.x, (int)(value));
            score += int(value);
        }
    }

    void draw() {
        pushMatrix();


        if (pos.y < cam.top) {
            translate(pos.x, car.pos.y + 80);
            image(omgSign, 0, 0);
        }
        else {
            translate(pos.x, pos.y);
            if (vel.y > 0)
                rotate(PI);

            if(vel.x > 0)
                rotate(PI);

            image(img,0, 0);

        }
        popMatrix();
    }
};


String randomCar() {
    return carImages.get(int(random(carImages.size())));
}
