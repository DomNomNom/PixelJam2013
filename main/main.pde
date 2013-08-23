
Car car;

void setup() {
  size(1280, 720);
  car = new Car();
}

void draw() {
  // rect(10,0, 100, 100);
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

