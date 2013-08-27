
class Camera {
    float carLine;

    float top;
    float bot;

    Camera() {
    }

    void update() {
        carLine = center.y * (
            1.6 // + car.vel.mag() / car.maxSpeed
        );

        top = -(carLine-car.pos.y);
        bot = top + windowSize.y;
    }

    void doTranslate() {
        if(gameState == 2){
            translate(0, carLine-car.pos.y);
        } else {
            translate(center.x-car.pos.x, center.y-car.pos.y);
        }
    }
}
