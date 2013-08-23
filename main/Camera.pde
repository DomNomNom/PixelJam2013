
class Camera {
    float carLine;

    float top;
    float bot;

    Camera() {
    }

    void update() {
        carLine = center.y * (
            1.7// + car.vel.mag() / car.maxSpeed
        );

        top = -(carLine-car.pos.y);
        bot = top + windowSize.y;
        // println("cam top: "+top);
    }

    void doTranslate() {
        translate(0, carLine-car.pos.y);
    }
}