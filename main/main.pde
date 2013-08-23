
PVector center; // center of the screen
PVector windowSize;

Car car;

Road road;

void setup() {
    ellipseMode(CENTER);
    imageMode(CENTER);
    rectMode(CENTER);

    windowSize = new PVector(1280, 720);
    center = PVector.mult(windowSize, 0.5);
    size(
        (int) windowSize.x,
        (int) windowSize.y
    );

    car = new Car();
    road = new Road();

}

void draw() {
    clear();

    // car.update();

    road.draw();
    car.draw();
}


void keyPressed() {
    if (key == CODED) {
        switch (keyCode) {
            case LEFT:
            case RIGHT:
            case UP:
            case DOWN:
                car.handleKey(keyCode);
                break;
        }

    }
}

