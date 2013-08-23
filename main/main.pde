
PVector center; // center of the screen
PVector windowSize;

float carLine;


Car car;
Camera cam;
Road road;

void setup() {
    ellipseMode(CENTER);
    imageMode(CENTER);
    rectMode(CENTER);

    windowSize = new PVector(1280, 720);
    center = PVector.mult(windowSize, 0.5);
    size(
        (int) windowSize.x,
        (int) windowSize.y,
        OPENGL
    );

    car = new Car();
    road = new Road();

    carLine = center.y * 1.5;
}

void draw() {
    clear();

    car.update();


    pushMatrix();
        translate(0, carLine-car.pos.y);
        road.draw();
        car.draw();
    popMatrix();
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
