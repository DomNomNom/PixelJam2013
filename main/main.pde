
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
    // rect(10,0, 100, 100);
    // image(
    //     road,
    //     center.x, center.y,
    //     windowSize.x, windowSize.y
    // );
    car.draw();
}

void keyPressed()  { key(keyCode, true);  }
void keyReleased() { key(keyCode, false); }
private void key(int keyCode, boolean pressed){
    if (key == CODED) {
        switch (keyCode) {
            case LEFT:
            case RIGHT:
            case UP:
            case DOWN:
                Input.handleKey(keyCode, pressed);
                break;
        }
    }
};
