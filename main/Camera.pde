
class Camera {
    float carLine;

    float top;
    float bot;

    Camera() {
        carLine = center.y * 1.5;
    }

    void update() {
        top = -(carLine-car.pos.y);
        bot = top + windowSize.y;
        // println("cam top: "+top);
    }

    void doTranslate() {
        translate(0, carLine-car.pos.y);
    }
}